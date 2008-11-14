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


  it "should only be available to authenticated users, except for the index action"
  it "should show a list of registered applications to a user"

  
  describe "new/create action" do 
    it "should show validation messages when creation is attempted with bad data"
    it "should create the registration and display the app details when good data is entered"
  end
  
  describe "show action" do
    it "should raise NotFound for the wrong user"
    it "should successfully show the app data for the app's owning user"
  end

  describe "edit/update action" do  
    it "should raise NotFound for the wrong user"
    it "should show a form to the app's owning user"
  end
  
  describe "delete action" do 
    it "should not be destroyable by ANY user"
  end

end

