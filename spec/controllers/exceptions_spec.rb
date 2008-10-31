require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Exceptions do
  
  before(:each) do
    Merb::Router.prepare do
      add_slice(:MerbAuthSliceFullfat)
      match("/sekkrit").to(:controller=>"exceptions", :action=>"unauthenticated").name(:unauthenticated) # a notional URL that will be handled by the exceptions controller
    end if standalone?
    @return_to_param = MerbAuthSliceFullfat[:return_to_param]
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have an unauthenticated action" do
    @controller = dispatch_to(Exceptions, :unauthenticated)
  end
  it "should redirect users to the login screen for HTML requests when unauthenticated is encountered" do
    @controller = get("/sekkrit", :format=>"html")
    @controller.status.should == 302
    @controller.should redirect_to(@controller.url(:merb_auth_slice_fullfat_login, @return_to_param=>"/sekkrit"))
    lambda {@controller.should redirect_to(@controller.url(:merb_auth_slice_fullfat_login, @return_to_param=>"/WRONG"))}.should fail
  end
  it "should redirect users to the login screen with the correct return_to if return_to is set" do
    @controller = get("/sekkrit", :format=>"html", @return_to_param=>"/returned")
    @controller.status.should == 302
    @controller.should redirect_to(@controller.url(:merb_auth_slice_fullfat_login, @return_to_param=>"/returned"))
    lambda {@controller.should redirect_to(@controller.url(:merb_auth_slice_fullfat_login, @return_to_param=>"/WRONG"))}.should fail
  end
  
  it "should return a 403 response for all other request types when unauthenticated is encountered"
  
end