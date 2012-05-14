require 'net/telnet'

class GaiteLed
  attr_reader :ledstrip

  def initialize(ip)
    @ledstrip = Net::Telnet::new("Host" => ip
                                 "Timeout" => 10)
  end

  def send_command(command)
    @ledstrip.login("foo", "bar")
    @ledstrip.cmd(command)
    @ledstrip.close
  end

  def loop_text(text)
    send_command("AFF #{text}")
  end
end
