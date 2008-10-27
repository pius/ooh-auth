require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceRestful::Sessions do
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbAuthSliceRestful) } if standalone?
    @prefix = MerbAuthSliceRestful[:path_prefix]
    # If running standalone, use the MockUser fixture class as the authenticatable model.
    #raise "hai im standalone" if config.standalone?
    
    @controller = dispatch_to(MerbAuthSliceRestful::Sessions, :index)
  end
   
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have an index action" do
    @controller.status.should == 200
    @controller.body.should contain('MerbAuthSliceRestful')
  end

  it "should have a route to the login form" do
    @controller.slice_url(:merb_auth_slice_restful, :login).should == "/#{@prefix}/login"
    @controller.slice_url(:login).should == "/#{@prefix}/login"

    @controller = get("/#{@prefix}/login")
    @controller.should be_kind_of(MerbAuthSliceRestful::Sessions)
    @controller.action_name.should == 'new'
  end
  
  it "should successfully render the login form" do
    @controller = get("/#{@prefix}/login")
    @controller.status.should == 200
    @controller.body.should contain("#{@prefix}/login") # intended to locate forms pointing to the authenticate method.
  end
  
  it "should have a route to submit the login form" do
    @controller.slice_url(:merb_auth_slice_restful, :authenticate).should == "/#{@prefix}/login"
    @controller.slice_url(:authenticate).should == "/#{@prefix}/login"
  end
  
  it "should authenticate a valid user on POST" do
      #@controller = post("/#{@prefix}/login")
      #@controller.should be_kind_of(MerbAuthSliceRestful::Sessions)
      #@controller.action_name.should == 'create'
  end
  
  it "should return a valid user to the return_to url if one was provided"
  it "should not authenticate an invalid user"
  it "should function with additional merb-auth strategies"
  
  it "should be mountable at the application root" do
    Merb::Router.prepare { slice( :MerbAuthSliceRestful, :name_prefix => nil, :path_prefix => nil ) }
      @controller = get("/login")
      @controller.slice_url(:login).should == "/login"
      @controller.should be_kind_of(MerbAuthSliceRestful::Sessions)
      @controller.action_name.should == 'new'
    Merb::Router.reset!
  end


end