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
  
  it "should render a password reset form"
  it "should render the form with a notification when a bad reset key is entered"
  it "should have a link to claim a notification directly by key"
  it "should allow the user to reset their pass when a correct key is used"
  it "should return the user to the host application once a reset is claimed"
  
end