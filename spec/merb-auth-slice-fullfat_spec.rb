require File.dirname(__FILE__) + '/spec_helper'

describe "OohAuth" do

  describe "::KeyGenerators" do
    
    before(:each) { @module = OohAuth::KeyGenerators }
    
    it "should generate a different memorable password every time" do
      past_items = []
      100.times do |i|
        key = @module::Password.gen
        key.should =~ /^\d+[a-z]+[A-Z][a-z]+$/
        past_items.should_not include(key)
        past_items << key
      end
    end
    it "should be able to generate long-form passphrases" do
      past_items = []
      100.times do |i|
        key = @module::Passphrase.gen(5)
        key.should =~ /^([a-z]+\s){4}([a-z]+)$/
        key.split(" ").length.should == 5
        past_items.should_not include(key)
        past_items << key
      end
    end
    it "should be able to generate alphanumeric nonmemorable keys" do
      past_items = []
      100.times do |i|
        key = @module::Alphanum.gen(50)
        key.should =~ /^[a-zA-Z0-9]{50}$/
        key.length.should == 50
        past_items.should_not include(key)
        past_items << key
      end
    end
    
  end

end