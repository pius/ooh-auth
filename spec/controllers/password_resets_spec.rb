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
  
  after(:each) do
    user_class.all.destroy!
    MerbAuthSliceFullfat::PasswordReset.all.destroy!
  end

  it "should have resource-type routing keyed by identifier" do
    pwr = MerbAuthSliceFullfat::PasswordReset.gen    
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :index)
    
    @controller.slice_url(:password_resets).should      == "/#{@prefix}/password_resets"
    @controller.slice_url(:password_reset, pwr).should  == "/#{@prefix}/password_resets/#{pwr.identifier}"
  end
  it "should use the key as identifer in all resource routes"
    
  it "should render a password reset form" do
    @controller = get(@controller.slice_url(:new_password_reset))
    @controller.status.should == 200
    @controller.action_name.should == "new"
  end
  it "should display the form with a message when given an incorrect identifier" do
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :create, password_reset_identifier_field=>"DSFARGEG")
    @controller.status.should == 404
    @controller.message.length.should > 10
    noko(@controller.body).css("form").length.should == 1
  end

  it "should successfully create a new reset when given a correct identifier" do
    user = user_class.gen
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :create, password_reset_identifier_field=>user.send(password_reset_identifier_field))
    @controller.status.should == 201
    @controller.headers['Location'].should == @controller.slice_url(:password_reset, @controller.assigns(:password_reset))
  end
  it "should redirect to the reset resource when given a correct identifier"

  
  it "should render the form with a notification when a bad reset key is entered"
  it "should have a link to claim a notification directly by key"
  it "should successfully reset the user's pass when the correct key is posted to update"
  it "should return the user to the host application once a reset is claimed"
  it "should allow cancellation of a passwordreset using the destroy action"
  
end