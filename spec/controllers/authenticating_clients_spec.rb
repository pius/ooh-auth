require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::AuthenticatingClients do
 
  before :all do
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
    end if standalone?
    @controller = dispatch_to(MerbAuthSliceFullfat::AuthenticatingClients, :index)
    @prefix = MerbAuthSliceFullfat[:path_prefix]
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  describe "index action" do
    it "should render successfully without authentication" do
      @controller.should be_successful
      lambda {@controller = dispatch_to(MerbAuthSliceFullfat::AuthenticatingClients, :new)}.should raise_error(Merb::Controller::Unauthenticated)
    end
    it "should show a list of clients when authenticated"
  end
  
  describe "new/create action" do 
    before :each do
      @user = user_class.gen

      @bad_authenticating_client_attrs = MerbAuthSliceFullfat::AuthenticatingClient.gen.attributes
      [:name].each  {|a| @bad_authenticating_client_attrs.delete(a) }
      
      @good_authenticating_client_attrs = MerbAuthSliceFullfat::AuthenticatingClient.gen(:kind=>"desktop").attributes
      [:id, :secret, :api_key].each  {|a| @good_authenticating_client_attrs.delete(a) }
      @good_authenticating_client_attrs[:name] = "unique fo realz"
      
      @controller = MerbAuthSliceFullfat::AuthenticatingClients.new(Merb::Test::RequestHelper::FakeRequest.new)
      @controller.request.session.user = @user
    end
    
    it "should show validation messages when creation is attempted with bad data" do
      ac_count = MerbAuthSliceFullfat::AuthenticatingClient.count
      @controller.create(@bad_authenticating_client_attrs)
      @controller.status.should == 200
      @controller.assigns(:authenticating_client).user_id.should == @user.id
      ac_count.should == MerbAuthSliceFullfat::AuthenticatingClient.count
    end
    it "should create the registration and display the app details when good data is entered" do
      ac_count = MerbAuthSliceFullfat::AuthenticatingClient.count
      @controller.create(@good_authenticating_client_attrs)
      @controller.assigns(:authenticating_client).should be_valid
      @controller.assigns(:authenticating_client).user_id.should == @user.id
      @controller.status.should == 201
      @controller.headers['Location'].should == @controller.slice_url(:authenticating_client, @controller.assigns(:authenticating_client))
      (ac_count + 1).should == MerbAuthSliceFullfat::AuthenticatingClient.count
    end
    it "should assign the authenticated user's ID regardless of user_id in the form data" do
      @controller.create(@good_authenticating_client_attrs.merge(:user_id=>@user.id+1000))
      @controller.assigns(:authenticating_client).user_id.should == @user.id
    end
  end
  
  describe "show action" do
    it "should raise NotFound for users other than the app's owning user" do
      
    end
    it "should successfully show the app data for the app's owning user"
  end

  describe "edit/update action" do
    before :each do
      @user = user_class.gen
      @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen(:user_id=>@user.id)
      @other_authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen(:user_id=>@user.id+1000)
      @controller = MerbAuthSliceFullfat::AuthenticatingClients.new(Merb::Test::RequestHelper::FakeRequest.new)
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
    it "cannot be used to reassign apps to other users" do
      @controller.update(@authenticating_client.id, {:user_id=>@user.id+50})
      @controller.assigns(:authenticating_client).user_id.should == @user.id
    end
    it "should show a form with errors when given bad input" do
      @controller.update(@authenticating_client.id, {:name=>""})
      @controller.should be_successful
      @controller.assigns(:authenticating_client).should_not be_valid
    end
    it "should redirect to the resource on successful update"
  end
  
  describe "delete action" do 
    it "should not be destroyable by ANY user"
  end

end

