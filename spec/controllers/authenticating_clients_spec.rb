require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe OohAuth::AuthenticatingClients do
 
  before :all do
    Merb::Router.prepare do 
      add_slice(:OohAuth)
    end if standalone?
    @controller = dispatch_to(OohAuth::AuthenticatingClients, :index)
    @prefix = OohAuth[:path_prefix]
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  describe "index action" do
    it "should render successfully without authentication" do
      @controller.should be_successful
      lambda {@controller = dispatch_to(OohAuth::AuthenticatingClients, :new)}.should raise_error(Merb::Controller::Unauthenticated)
    end
    it "should show a list of clients when authenticated"
  end
  
  describe "new/create action" do 
    before :each do
      @user = user_class.gen

      @bad_authenticating_client_attrs = OohAuth::AuthenticatingClient.gen.attributes
      [:name, :user_id].each  {|a| @bad_authenticating_client_attrs.delete(a) }
      
      @good_authenticating_client_attrs = OohAuth::AuthenticatingClient.gen(:kind=>"desktop").attributes
      [:id, :secret, :api_key, :user_id].each  {|a| @good_authenticating_client_attrs.delete(a) }
      @good_authenticating_client_attrs[:name] = "unique fo realz"
      
      @controller = OohAuth::AuthenticatingClients.new(Merb::Test::RequestHelper::FakeRequest.new)
      @controller.request.session.user = @user
    end
    
    it "should show validation messages when creation is attempted with bad data" do
      ac_count = OohAuth::AuthenticatingClient.count
      @controller.create(@bad_authenticating_client_attrs)
      @controller.status.should == 200
      @controller.assigns(:authenticating_client).user_id.should == @user.id
      ac_count.should == OohAuth::AuthenticatingClient.count
    end
    it "should create the registration and display the app details when good data is entered" do
      ac_count = OohAuth::AuthenticatingClient.count
      @controller.create(@good_authenticating_client_attrs)
      @controller.assigns(:authenticating_client).should be_valid
      @controller.assigns(:authenticating_client).user_id.should == @user.id
      @controller.status.should == 201
      @controller.headers['Location'].should == @controller.slice_url(:authenticating_client, @controller.assigns(:authenticating_client))
      (ac_count + 1).should == OohAuth::AuthenticatingClient.count
    end
  end
  
  describe "show action" do
    before :each do
      @user = user_class.gen
      @authenticating_client = OohAuth::AuthenticatingClient.gen(:user=>@user)
      @other_authenticating_client = OohAuth::AuthenticatingClient.gen
      @controller = OohAuth::AuthenticatingClients.new(Merb::Test::RequestHelper::FakeRequest.new)
      @controller.request.session.user = @user
    end
    
    it "should raise NotFound for users other than the app's owning user" do
      lambda { @controller.show(@other_authenticating_client.id)}.should raise_error(Merb::Controller::NotFound)
    end
    it "should successfully show the app data for the app's owning user" do
      @controller.show(@authenticating_client.id)
      @controller.should be_successful
    end
  end

  describe "edit/update action" do
    before :each do
      @user = user_class.gen
      @authenticating_client = OohAuth::AuthenticatingClient.gen(:user=>@user)
      @other_authenticating_client = OohAuth::AuthenticatingClient.gen
      @controller = OohAuth::AuthenticatingClients.new(Merb::Test::RequestHelper::FakeRequest.new)
      @controller.request.session.user = @user
    end
    
    it "should raise NotFound for the wrong user on GET" do
      lambda {@controller.edit(@other_authenticating_client.id)}.should raise_error(Merb::Controller::NotFound)
    end
    it "should raise NotFound for the wrong user on POST/PUT" do
      lambda {@controller.update(@other_authenticating_client.id, {:name=>"renamed!"})}.should raise_error(Merb::Controller::NotFound)
    end
    it "should show a form to the app's owning user" do
      @controller.edit(@authenticating_client.id)
      @controller.should be_successful
    end
    it "cannot be used to reassign apps to other users" #do
    # Waiting on ticket: http://wm.lighthouseapp.com/projects/4819/tickets/669-problem-with-protected-attribute-mass-assignment#ticket-669-1
    # related to problems preventing mass-assignment.
    #  @controller.update(@authenticating_client.id, {:user_id=>@user.id+50})
    #  @controller.assigns(:authenticating_client).user_id.should == @user.id
    #end
    it "should show a form with errors when given bad input" do
      @controller.update(@authenticating_client.id, {:name=>""})
      @controller.should be_successful
      @controller.assigns(:authenticating_client).should_not be_valid
    end
    it "should redirect to the resource on successful update" do
      @controller.update(@authenticating_client.id, {:name=>"renamed renamed renamed"})
      @controller.status.should == 302
      @controller.should redirect_to(@controller.slice_url(:authenticating_client, @controller.assigns(:authenticating_client)))
      @controller.assigns(:authenticating_client).should be_valid      
    end
  end
  
  describe "delete action" do 
    it "should not be destroyable by any user other than the owning user"
  end

end

