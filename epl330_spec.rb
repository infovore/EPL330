require './epl330.rb'
require 'rspec'

describe EPL330, "processing text" do
  before(:each) do
    Net::Telnet.stub(:new)
    @e = EPL330.new('localhost')
  end

  it "Should leave text in uppercase alone" do
    @e.process_text("TEXT").should == "TEXT"
  end

  it "Should wrap text in lowercase appropriately" do
    @e.process_text("Text").should == "T{{EXT}}"
  end

  it "Should wrap text in lowercase appropriately across multiple words." do
    @e.process_text("Hello World").should == "H{{ELLO}} W{{ORLD}}"
  end
end
