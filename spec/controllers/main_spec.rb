require File.dirname(__FILE__) + '/../spec_helper'

describe "MerbAuthSliceRestful::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbAuthSliceRestful) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbAuthSliceRestful::Main, :index)
    controller.slice.should == MerbAuthSliceRestful
    controller.slice.should == MerbAuthSliceRestful::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(MerbAuthSliceRestful::Main, :index)
    controller.status.should == 200
    controller.body.should contain('MerbAuthSliceRestful')
  end
  
  it "should work with the default route" do
    controller = get("/merb-auth-slice-restful/main/index")
    controller.should be_kind_of(MerbAuthSliceRestful::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/merb-auth-slice-restful/index.html")
    controller.should be_kind_of(MerbAuthSliceRestful::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(MerbAuthSliceRestful::Main, 'index')
    
    url = controller.url(:merb_auth_slice_restful_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/merb-auth-slice-restful/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:merb_auth_slice_restful_index, :format => 'html')
    url.should == "/merb-auth-slice-restful/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:merb_auth_slice_restful_home)
    url.should == "/merb-auth-slice-restful/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbAuthSliceRestful::Main, :index)
    controller.public_path_for(:image).should == "/slices/merb-auth-slice-restful/images"
    controller.public_path_for(:javascript).should == "/slices/merb-auth-slice-restful/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb-auth-slice-restful/stylesheets"
    
    controller.image_path.should == "/slices/merb-auth-slice-restful/images"
    controller.javascript_path.should == "/slices/merb-auth-slice-restful/javascripts"
    controller.stylesheet_path.should == "/slices/merb-auth-slice-restful/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    MerbAuthSliceRestful::Main._template_root.should == MerbAuthSliceRestful.dir_for(:view)
    MerbAuthSliceRestful::Main._template_root.should == MerbAuthSliceRestful::Application._template_root
  end

end