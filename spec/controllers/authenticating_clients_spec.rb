require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a MerbAuthSliceFullfat::Authenticating_client exists" do
  MerbAuthSliceFullfat::AuthenticatingClient.all.destroy!
  request(resource(:MerbAuthSliceFullfat::Authenticating_clients), :method => "POST", 
    :params => { :MerbAuthSliceFullfat::Authenticating_client => { :id => nil }})
end

describe "resource(:MerbAuthSliceFullfat::Authenticating_clients)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:MerbAuthSliceFullfat::Authenticating_clients))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of MerbAuthSliceFullfat::Authenticating_clients" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a MerbAuthSliceFullfat::Authenticating_client exists" do
    before(:each) do
      @response = request(resource(:MerbAuthSliceFullfat::Authenticating_clients))
    end
    
    it "has a list of MerbAuthSliceFullfat::Authenticating_clients" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      MerbAuthSliceFullfat::AuthenticatingClient.all.destroy!
      @response = request(resource(:MerbAuthSliceFullfat::Authenticating_clients), :method => "POST", 
        :params => { :MerbAuthSliceFullfat::Authenticating_client => { :id => nil }})
    end
    
    it "redirects to resource(:MerbAuthSliceFullfat::Authenticating_clients)" do
      @response.should redirect_to(resource(MerbAuthSliceFullfat::AuthenticatingClient.first), :message => {:notice => "MerbAuthSliceFullfat::Authenticating_client was successfully created"})
    end
    
  end
end

describe "resource(@MerbAuthSliceFullfat::Authenticating_client)" do 
  describe "a successful DELETE", :given => "a MerbAuthSliceFullfat::Authenticating_client exists" do
     before(:each) do
       @response = request(resource(MerbAuthSliceFullfat::AuthenticatingClient.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:MerbAuthSliceFullfat::Authenticating_clients))
     end

   end
end

describe "resource(:MerbAuthSliceFullfat::Authenticating_clients, :new)" do
  before(:each) do
    @response = request(resource(:MerbAuthSliceFullfat::Authenticating_clients, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@MerbAuthSliceFullfat::Authenticating_client, :edit)", :given => "a MerbAuthSliceFullfat::Authenticating_client exists" do
  before(:each) do
    @response = request(resource(MerbAuthSliceFullfat::AuthenticatingClient.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@MerbAuthSliceFullfat::Authenticating_client)", :given => "a MerbAuthSliceFullfat::Authenticating_client exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(MerbAuthSliceFullfat::AuthenticatingClient.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @MerbAuthSliceFullfat::Authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.first
      @response = request(resource(@MerbAuthSliceFullfat::Authenticating_client), :method => "PUT", 
        :params => { :MerbAuthSliceFullfat::Authenticating_client => {:id => @MerbAuthSliceFullfat::Authenticating_client.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@MerbAuthSliceFullfat::Authenticating_client))
    end
  end
  
end

