require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::Sessions do
  
  before :all do
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
      match("/secrets").to(:controller=>"merb_auth_slice_fullfat/secrets", :action=>"index").name(:secrets)
    end if standalone?
    @prefix = MerbAuthSliceFullfat[:path_prefix]
    # If running standalone, use the MockUser fixture class as the authenticatable model.
    #raise "hai im standalone" if config.standalone?
    
    @controller = dispatch_to(MerbAuthSliceFullfat::Sessions, :index)
  end
   
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have an index action" do
    @controller.status.should == 200
    @controller.body.should contain('MerbAuthSliceFullfat')
  end

  it "should have a route to the login form" do
    @controller.slice_url(:merb_auth_slice_fullfat, :new_session).should == "/#{@prefix}/sessions/new"
    @controller.slice_url(:new_session).should == "/#{@prefix}/sessions/new"

    @controller = get(@controller.slice_url(:new_session))
    @controller.should be_kind_of(MerbAuthSliceFullfat::Sessions)
    @controller.action_name.should == 'new'
  end
  
  it "should successfully render the login form" do
    @controller = get(@controller.slice_url(:new_session))
    @controller.status.should == 200
    @controller.body.should contain("Login") # intended to locate forms pointing to the authenticate method.
  end
  
  it "should have a route to submit the login form" do
    @controller.slice_url(:merb_auth_slice_fullfat, :sessions).should == "/#{@prefix}/sessions"
    @controller.slice_url(:sessions).should == "/#{@prefix}/sessions"
  end
  
  it "should authenticate a valid user on POST" do
    user = user_class.gen
    @controller = post(@controller.slice_url(:sessions), login_param=>user.login, password_param=>"#{user.login}_goodpass")
    @controller.should be_kind_of(MerbAuthSliceFullfat::Sessions)
    @controller.action_name.should == 'create'
    @controller.session[:user].should be_kind_of(Numeric)
    user_class.get(@controller.session[:user]).should == @controller.assigns(:user)
  end
  
  it "should start a browser session when authenticated" do
    controllers = [Exceptions, MerbAuthSliceFullfat::Sessions]
    user = user_class.gen
    with_cookies *controllers do |jar|
      # okay - secret page should cause an auth error.
      lambda { get("/secrets") }.should raise_error(Merb::Controller::Unauthenticated)
      @controller.session.user.should be_nil
      # so let's authenticate
      @auth_controller = post(@controller.slice_url(:sessions), login_param=>user.login, password_param=>"#{user.login}_goodpass", return_to_param=>"/success")
      # assert that the auth happened
      @auth_controller.should redirect_to("/success")
      # load a new page and check the session
      @controller = get(@controller.slice_url(:new_session))
      @controller.session.user.should be_kind_of(user_class)
    end
  end

  it "should not authenticate an invalid user on POST" do
    lambda do 
      @controller = post(@controller.slice_url(:sessions), login_param=>"THE POWER LEVEL", password_param=>"ITS OVER NINE THOUSAAAAAAAAND")
    end.should raise_error(Merb::Controller::Unauthenticated)
  end
  
  it "should return a valid user to the return_to url if one was provided" do
    user = user_class.gen
    @controller = post(@controller.slice_url(:sessions),  login_param=>user.login, password_param=>"#{user.login}_goodpass", return_to_param=>"/success")
    @controller.status.should == 302
    @controller.should redirect_to("/success")
  end
  
  it "should function with additional merb-auth strategies" do
    # Register a totally passive strategy just designed to trigger a variable when queried.
    class CustomStrategyDetector
      cattr_accessor :has_run
      @@has_run = false
    end
    Merb::Authentication.register :custom_strategy, MerbAuthSliceFullfat.root / "mocks" / "custom_auth_strategy.rb"
    Merb::Authentication.activate! :custom_strategy
    CustomStrategyDetector.has_run.should be_false
    
    lambda do
      @controller = post(@controller.slice_url(:sessions), login_param=>"THE 90'S", password_param=>"WERE UNDERRATED", return_to_param=>"/success")
    end.should raise_error(Merb::Controller::Unauthenticated)
    
    CustomStrategyDetector.has_run.should be_true
  end
  
  it "should be mountable at the application root" do
    Merb::Router.prepare { slice( :MerbAuthSliceFullfat, :name_prefix => nil, :path_prefix => nil ) }
      @controller = get("/sessions/new")
      @controller.slice_url(:new_session).should == "/sessions/new"
      @controller.should be_kind_of(MerbAuthSliceFullfat::Sessions)
      @controller.action_name.should == 'new'
    Merb::Router.reset!
  end


end