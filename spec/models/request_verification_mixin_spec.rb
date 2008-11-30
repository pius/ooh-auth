require File.join( File.dirname(__FILE__), '..', "spec_helper" )
require 'digest/sha1'

describe MerbAuthSliceFullfat::Request::VerificationMixin do
  
  before :all do
    # set the api key to a known value for the purposes of this test suite
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen(:api_key=>"fishsticks")
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
    end if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be included in the Merb::Request and FakeRequest classes on slice initialisation" do
    Merb::Request.include?(MerbAuthSliceFullfat::Request::VerificationMixin).should be_true
    Merb::Test::RequestHelper::FakeRequest.include?(MerbAuthSliceFullfat::Request::VerificationMixin).should be_true
  end
  
  it "should verify that a correctly-signed GET request is signed using GET parameters" do
    req = request_signed_by(
      @authenticating_client, 
      { :a=>"1", :b=>"3", :c=>"2"}
    )
    req.method.should == :get
    req.authenticating_client.should == @authenticating_client
    req.signed?.should be_true
  end
  
  it "should include POST parameters when signing POST requests" do
    req = request_signed_by(
      @authenticating_client, 
      { :a=>"1", :b=>"3", :c=>"2"},
      { :post_me => "a_var" },
      {:request_method=>"POST"}
    )
    req.method.should == :post
    req.authenticating_client.should == @authenticating_client
    req.signed?.should be_true    
  end
  it "should fail to verify that a request is signed if the signature is in any way wrong" do
    get_params = {
      :a=>"1", 
      :api_key=>"fishsticks",
      :api_signature=>"I R HACKIN YOO LOL"
    }
    param_string = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
    req = fake_request(
      :query_string => param_string, 
      :http_host => "test.fullfat.com", 
      :request_uri=>"/secret/"
    )
    req.authenticating_client.should == @authenticating_client
    req.signed?.should be_false
  end
  
  [:api_key, :api_token, :api_signature, :api_receipt, :api_permissions].each do |prop|
    it "should make #{prop} accessible as a method when set as a parameter" do
      req = fake_request(:query_string=>"#{MerbAuthSliceFullfat[:"#{prop}_param"]}=value_for_#{prop}")
      req.send(prop).should == "value_for_#{prop}"
    end
  end  
  
end