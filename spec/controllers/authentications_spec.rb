require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::Authentications do

  before :all do
    @user = user_class.gen
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen
    @other_authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen
    @receipt = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_client, 1.hour.since, @user)
    @bad_receipt = MerbAuthSliceFullfat::Authentication.create_receipt(@other_authenticating_client, 1.hour.since, @user)
    @controller = dispatch_to(MerbAuthSliceFullfat::Sessions, :index)
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
    end if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
    
  %w(js yaml xml).each do |format|
    describe "index action (#{format} format)" do
      it "should generate an anonymous receipt when sent GET with an api key and no other information." do
        @controller = MerbAuthSliceFullfat::Authentications.new(
          request_signed_by(@authenticating_client, {"format"=>format}, {}, {:request_uri=>"/authentications"})
        )
        @controller.index
        @controller.should be_successful
        auth = @controller.assigns(:authentication)
        auth.should be_kind_of(MerbAuthSliceFullfat::Authentication)
        auth.activated?.should be_false
      end
      it "should generate nothing and return a 406 not acceptable when the request contains only an incorrect API key" do
        @controller = MerbAuthSliceFullfat::Authentications.new(
          request_signed_by(@authenticating_client, {"format"=>format, "api_key"=>"GREAT FAIL UNTO THEE"}, {}, {:request_uri=>"/authentications"})
        )
        lambda {@controller.index}.should raise_error(Merb::Controller::NotAcceptable)
      end
      it "should generate an auth token when sent GET with an api token and api receipt code." do
        @controller = MerbAuthSliceFullfat::Authentications.new(
          request_signed_by(@authenticating_client, {"format"=>format, "api_receipt"=>@receipt.receipt}, {}, {:request_uri=>"/authentications"})
        )
        @controller.index
        @controller.should be_successful
        auth = @controller.assigns(:authentication)
        auth.should be_kind_of(MerbAuthSliceFullfat::Authentication)
        auth.activated?.should be_true
      end
      it "should not generate an auth token if the receipt referenced by the given receipt code does not belong to the application referenced by the given api key" do
        @controller = MerbAuthSliceFullfat::Authentications.new(
          request_signed_by(@authenticating_client, {"format"=>format, "api_receipt"=>@bad_receipt.receipt}, {}, {:request_uri=>"/authentications"})
        )
        lambda {@controller.index}.should raise_error(Merb::Controller::NotFound)
      end
    end
  end
  
  describe "new/create action (desktop process)" do
    it "should display a form to the user and locate the correct receipt from the database on GET"
    it "should require a user to be logged in via session" do
      lambda do 
        @controller = get(sign_url_with(@authenticating_client, @controller.slice_url(:new_authentication)))
      end.should raise_error(Merb::Controller::Unauthenticated)
    end
    it "should display nothing and return a 406 when the params contain an api key which is invalid" do
      lambda do 
        @controller = get(sign_url_with(@authenticating_client, @controller.slice_url(:new_authentication), "api_key"=>"DIDDLYSQUAT"))
      end.should raise_error(Merb::Controller::NotAcceptable)
    end
    it "should return a 406 when the given api key belongs to a desktop app and no receipt is given"
    it "should display nothing and return a 406 not acceptable when the request contains an invalid api receipt"
  end
  
  describe "new/create action (web-based process)" do
    it "should display a form to the user on GET"
    it "should display successfully when no receipt is given"
  end
  
  describe "new/create action (common to all processes)" do
    it "should require a logged-in user"
    it "should display nothing and return a 406 not acceptable when the request contains an invalid permission level"
  end
  
  describe "edit/update action" do
    it "should only be accessible by the token's owning user"
    it "should return 404 not found for other users"
    it "should only allow the expiry and permission level to be altered"
  end
  
  describe "delete/destroy action" do
    it "should only be accessible by the token's owning user"
    it "should return a 404 not found for other users"
    it "should remove all authentications for this user/application if multiple records are present"
  end
  
end