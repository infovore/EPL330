require 'net/telnet'

class EPL330_Exception < Exception

end

class EPL330
  attr_reader :ledstrip

  def initialize(ip)
    @ledstrip = Net::Telnet::new("Host" => ip,
                                 "Waittime" => 2.0,
                                 "Prompt" => /.*/
                                )
  end

  def send_command(command)
    return_value = @ledstrip.cmd("#{command}")
    if
      return_value =~ /erreurs/
      raise EPL330_Exception, return_value
    else
      return_value
    end
  end

  def set(key, value)
    @ledstrip.cmd("SET #{key} = #{value}")
  end

  def get(key)
    @ledstrip.cmd("SET #{key}")
  end

  def string_for_text(text, options={})
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
        entry_string = "ee"
      when :center
        entry_string = "ec"
      when :immediate
        entry_string = "ei"
      when :curtain
        entry_string = "er"
      when :top
        entry_string = "eh"
      when :bottom
        entry_string = "eb"
      end
    end

    if options.has_key?(:exit)
      case options[:exit]
      when :left
        exit_string = "sg"
      when :right
        exit_string = "sd"
      when :ends
        exit_string = "se"
      when :center
        exit_string = "sc"
      when :immediate
        exit_string = "si"
      when  :curtain
        exit_string = "sr"
      when :top
        exit_string = "sh"
      when :bottom
        exit_string = "sb"
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

    if options.has_key?(:pause)
      pause_string = "a#{options[:pause]}"
    end

    actual_text = process_text(text)
    "#{pos_string}#{entry_string}#{actual_text}#{pause_string}#{exit_string}"
  end

  def loop_text(text,options)
    send_command("AFF #{string_for_text(text, options)}")
  end

  def loop_strings(strings)
    send_command("AFF #{strings.join}")
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
