require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceRestful::Sessions do
  
  before :all do
    Merb::Router.prepare { all_slices } if standalone?
    @controller = dispatch_to(MerbAuthSliceRestful::Sessions, :index)
  end
   
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have an index action" do
    @controller.status.should == 200
    @controller.body.should contain('MerbAuthSliceRestful')
  end

  it "should work with the default route" do
    @controller = get("/login")
    @controller.slice_url :login
    @controller.should be_kind_of(MerbAuthSliceRestful::Sessions)
    @controller.action_name.should == 'new'
  end
  
  it "should render a login form"
  it "should offer HTTP Basic auth"

end