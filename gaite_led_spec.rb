require './gaite_led.rb'
require 'rspec'

describe GaiteLed, "processing text" do
  before(:each) do
    Net::Telnet.stub(:new)
    @gl = GaiteLed.new('localhost')
  end

  it "Should leave text in uppercase alone" do
    @gl.process_text("TEXT").should == "TEXT"
  end

  it "Should wrap text in lowercase appropriately" do
    @gl.process_text("Text").should == "T{{EXT}}"
  end

  it "Should wrap text in lowercase appropriately across multiple words." do
    @gl.process_text("Hello World").should == "H{{ELLO}} W{{ORLD}}"
  end
end
