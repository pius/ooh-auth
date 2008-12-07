require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe OohAuth::Application do
  
  before :all do
    Merb::Router.prepare { add_slice(:OohAuth) } if standalone?
    @controller = dispatch_to(OohAuth::Public, :index)
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    @controller.slice.should == OohAuth
    @controller.slice.should == OohAuth::Public.slice
  end

  it "should have helper methods for dealing with public paths" do
    @controller.public_path_for(:image).should == "/slices/ooh-auth/images"
    @controller.public_path_for(:javascript).should == "/slices/ooh-auth/javascripts"
    @controller.public_path_for(:stylesheet).should == "/slices/ooh-auth/stylesheets"
    
    @controller.image_path.should == "/slices/ooh-auth/images"
    @controller.javascript_path.should == "/slices/ooh-auth/javascripts"
    @controller.stylesheet_path.should == "/slices/ooh-auth/stylesheets"
  end

  it "should have a slice-specific _template_root" do
    OohAuth::Public._template_root.should == OohAuth.dir_for(:view)
    OohAuth::Public._template_root.should == OohAuth::Application._template_root
  end
  
  
end