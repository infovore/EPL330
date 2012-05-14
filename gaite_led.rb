require 'net/telnet'

class GaiteLed_Exception < Exception

end

class GaiteLed
  attr_reader :ledstrip

  def initialize(ip)
    @ledstrip = Net::Telnet::new("Host" => ip,
                                 "Waittime" => 2.0,
                                 "Prompt" => /.*/
                                )
  end

  def send_command(command)
    @ledstrip.cmd("#{command}")
  end

  def loop_text(text, options={})
    entry_string = ""
    exit_string = ""
    pos_string = ""

    if options.has_key?(:entry)
      case options[:entry]
      when :left
        entry_string = "eg"
      when :right
        entry_string = "ed"
      when :ends
        entry_string = "eE"
      when :center
        entry_string = "ec"
      when :immediate
        entry_string = "ei"
      when :curtain
        entry_string = "er"
      end
    end

    if options.has_key?(:exit)
      case options[:exit]
      when :left
        exit_string = "sg"
      when :right
        exit_string = "sd"
      when :ends
        exit_string = "sE"
      when :center
        exit_string = "sc"
      when :immediate
        exit_string = "si"
      when :curtain
        exit_string = "sr"
      end
    end

    if options.has_key?(:start_pos)
      if options.has_key?(:entry)
        pos_string << "p#{options[:start_pos]}"
      end
    end

    if options.has_key?(:end_pos)
      if options.has_key?(:entry)
        pos_string << "#{options[:end_pos]}"
      end
    end

    actual_text = process_text(text)
    send_command("AFF #{pos_string}#{entry_string}#{actual_text}#{exit_string}")
  end

  def process_text(text)
    characters = text.split("")
    lowercaseflag = false
    output_text = ""
    characters.each do |c|
      if c =~ /[a-z]/
        unless lowercaseflag
          output_text << "{{"
          lowercaseflag = true
        end
        output_text << c.upcase
      else
        if lowercaseflag
          output_text << "}}"
          lowercaseflag = false
        end
        output_text << c
      end
    end
    if lowercaseflag
      output_text << "}}"
    end
    output_text
  end

end
