require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceRestful::Application do
  
  before(:each) do
    Merb::Router.prepare { add_slice(:MerbAuthSliceRestful) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(MerbAuthSliceRestful::Sessions, :index)
    controller.slice.should == MerbAuthSliceRestful
    controller.slice.should == MerbAuthSliceRestful::Sessions.slice
  end

  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(MerbAuthSliceRestful::Sessions, :index)
    controller.public_path_for(:image).should == "/slices/merb-auth-slice-restful/images"
    controller.public_path_for(:javascript).should == "/slices/merb-auth-slice-restful/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/merb-auth-slice-restful/stylesheets"

    controller.image_path.should == "/slices/merb-auth-slice-restful/images"
    controller.javascript_path.should == "/slices/merb-auth-slice-restful/javascripts"
    controller.stylesheet_path.should == "/slices/merb-auth-slice-restful/stylesheets"
  end

  it "should have a slice-specific _template_root" do
    MerbAuthSliceRestful::Sessions._template_root.should == MerbAuthSliceRestful.dir_for(:view)
    MerbAuthSliceRestful::Sessions._template_root.should == MerbAuthSliceRestful::Application._template_root
  end
  
  
end