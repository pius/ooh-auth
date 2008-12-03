require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::Application do
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbAuthSliceFullfat) } if standalone?
    @controller = dispatch_to(MerbAuthSliceFullfat::Public, :index)
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    @controller.slice.should == MerbAuthSliceFullfat
    @controller.slice.should == MerbAuthSliceFullfat::Public.slice
  end

  it "should have helper methods for dealing with public paths" do
    @controller.public_path_for(:image).should == "/slices/merb-auth-slice-fullfat/images"
    @controller.public_path_for(:javascript).should == "/slices/merb-auth-slice-fullfat/javascripts"
    @controller.public_path_for(:stylesheet).should == "/slices/merb-auth-slice-fullfat/stylesheets"
    
    @controller.image_path.should == "/slices/merb-auth-slice-fullfat/images"
    @controller.javascript_path.should == "/slices/merb-auth-slice-fullfat/javascripts"
    @controller.stylesheet_path.should == "/slices/merb-auth-slice-fullfat/stylesheets"
  end

  it "should have a slice-specific _template_root" do
    MerbAuthSliceFullfat::Public._template_root.should == MerbAuthSliceFullfat.dir_for(:view)
    MerbAuthSliceFullfat::Public._template_root.should == MerbAuthSliceFullfat::Application._template_root
  end
  
  
end