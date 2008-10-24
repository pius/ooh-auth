require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Exceptions, "index action" do
  
  before(:each) do
    Merb::Router.prepare { all_slices } if standalone?
    dispatch_to(Exceptions, :unauthenticated)
  end
  
  it "should have an unauthenticated action"
  it "should redirect users to the login screen for HTML requests when unauthenticated is encountered"
  it "should return a 403 response for all other request types when unauthenticated is encountered"
  
end