require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Exceptions do
  
  before(:each) do
    Merb::Router.prepare { add_slice(:MerbAuthSliceFullfat) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have an unauthenticated action"
  it "should redirect users to the login screen for HTML requests when unauthenticated is encountered"
  it "should return a 403 response for all other request types when unauthenticated is encountered"
  
end