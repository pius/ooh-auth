require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuthSliceFullfat" do

  describe "::Secrets (mock controller)" do
    
    before :all do
      Merb::Router.reset!
      Merb::Router.prepare do 
        add_slice(:MerbAuthSliceFullfat, :name_prefix => nil, :path_prefix => nil) 
        match('/secrets').to(:controller => 'merb_auth_slice_fullfat/secrets', :action =>'index')
      end if standalone?
    end
    
    after :all do
      Merb::Router.reset!
    end
    
    it "should raise unauthenticated and direct to the login page for HTML requests if the user is not authenticated" do
      lambda { @controller = dispatch_to(MerbAuthSliceFullfat::Secrets, :index, :format=>"html") }.should raise_error(Merb::Controller::Unauthenticated)
    end
    it "should raise unauthenticated for other requests" do
      lambda { @controller = dispatch_to(MerbAuthSliceFullfat::Secrets, :index, :format=>"xml") }.should raise_error(Merb::Controller::Unauthenticated)
    end
    it "should display for authenticated users using HTTP auth" do
      user = user_class.gen
      @controller = dispatch_with_basic_authentication_to(
        MerbAuthSliceFullfat::Secrets, :index, 
        user.login, "#{user.login}_goodpass",
        :format=>"xml"
      ) #dispatch_with_basic_authentication_to
      @controller.status.should == 200
      @controller.should be_kind_of(MerbAuthSliceFullfat::Secrets)
    end
    
    it "should display for authenticated users using session auth"    
    it "should be displayable with a valid API authentication token"
    
  end

  describe "::KeyGenerators" do
    
    before(:each) { @module = MerbAuthSliceFullfat::KeyGenerators }
    
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