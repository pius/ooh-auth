require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::PasswordResets do
  
  before :all do
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
      match("/secrets").to(:controller=>"merb_auth_slice_fullfat/secrets", :action=>"index").name(:secrets)
    end if standalone?
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :index)
    @prefix = MerbAuthSliceFullfat[:path_prefix]
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  it "should have resource-type routing" do
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :index)
    @controller.slice_url(:password_resets).should == "/#{@prefix}/password_resets"
    @controller = get(@controller.slice_url(:password_resets))
    @controller.status.should == 200
  end
  it "should use the key as identifer in all resource routes"
    
  it "should render a password reset form" do
    @controller = get(@controller.slice_url(:new_password_reset))
    @controller.status.should == 200
    @controller.action_name.should == "new"
  end
  it "should fail with a message when an incorrect user identifier is used to create a new reset" do
    reset_count = MerbAuthSliceFullfat::PasswordReset.count
    
  end
  it "should successfully create a new reset when given a correct identifier"
  
  it "should render the form with a notification when a bad reset key is entered"
  it "should have a link to claim a notification directly by key"
  it "should successfully reset the user's pass when the correct key is posted to update"
  it "should return the user to the host application once a reset is claimed"
  it "should allow cancellation of a passwordreset using the destroy action"
  
end