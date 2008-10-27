require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceRestful::PasswordResets, "index action" do
  
  before :each do
    Merb::Router.prepare { add_slice(:MerbAuthSliceRestful) } if standalone?
    dispatch_to(MerbAuthSliceRestful::PasswordResets, :index)
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should render a password reset form"
  it "should render the form with a notification when a bad reset key is entered"
  it "should have a link to claim a notification directly by key"
  it "should allow the user to reset their pass when a correct key is used"
  it "should return the user to the host application once a reset is claimed"
  
end