require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::Authentications do

  before :all do
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen(:api_key=>"fishsticks")
  end

  describe "index action" do
    it "should generate an anonymous receipt when sent GET with an api key and no other information."
    it "should generate nothing and return a 406 not acceptable when the request contains only an incorrect API key"
    it "should generate an auth token when sent GET with an api token and api receipt code."
    it "should not generate an auth token if the receipt referenced by the given receipt code does not belong to the application referenced by the given api key"
  end
  
  describe "new/create action (desktop process)" do
    it "should display a form to the user and locate the correct receipt from the database on GET"
    it "should display nothing and return a 406 when the params contain an api key which is invalid or which belongs to a web-based application when no api receipt was given"
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