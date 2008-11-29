require File.join( File.dirname(__FILE__), '..', "spec_helper" )
require 'digest/sha1'

describe MerbAuthSliceFullfat::Request::VerificationMixin do
  
  before :all do
    # set the api key to a known value for the purposes of this test suite
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen(:api_key=>"fishsticks")
  end
  
  it "should be included in the Merb::Request and FakeRequest classes on slice initialisation" do
    Merb::Request.include?(MerbAuthSliceFullfat::Request::VerificationMixin).should be_true
    Merb::Test::RequestHelper::FakeRequest.include?(MerbAuthSliceFullfat::Request::VerificationMixin).should be_true
  end
  
  it "should verify that a correctly-signed GET request is signed using GET parameters" do
    get_params = { "a"=>"1", "b"=>"3", "c"=>"2", "api_key"=>"fishsticks" }
    get_params[:api_signature] = Digest::SHA1.hexdigest("#{@authenticating_client.secret}httptest.fullfat.com/secret/#{get_params.keys.sort.join("")}#{get_params.values.sort.join("")}")
    param_string = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
    req = fake_request(
      :query_string => param_string, 
      :http_host => "test.fullfat.com", 
      :request_uri=>"/secret/"
    )
    req.full_uri.should == "http://test.fullfat.com/secret/"
    req.authenticating_client.should == @authenticating_client
    req.signed?.should be_true
  end
  
  it "should include POST parameters when signing POST requests" do
    get_params = { "a"=>"1", "b"=>"3", "c"=>"2", "api_key"=>"fishsticks" }
    post_params = { "post_me" => "a_var" }
    all_params = get_params.merge(post_params)
    post_param_string = post_params.collect{|k,v| "#{k}=#{v}"}.join("&") #
    get_params[:api_signature] = Digest::SHA1.hexdigest("#{@authenticating_client.secret}httptest.fullfat.com/secret/#{all_params.keys.sort.join("")}#{all_params.values.sort.join("")}")
    get_param_string = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
    
    req = fake_request({
      :request_method => "POST",
      :query_string => get_param_string, 
      :http_host => "test.fullfat.com", 
      :request_uri=>"/secret/"
    },
      :post_body=> post_param_string
    )
    req.full_uri.should == "http://test.fullfat.com/secret/"
    req.authenticating_client.should == @authenticating_client
    req.signed?.should be_true
  end
  it "should fail to verify that a request is signed if the signature is in any way wrong" do
    get_params = {
      "a"=>"1", 
      "api_key"=>"fishsticks",
      "api_signature"=>"I R HACKIN YOO LOL"
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
  
  [:api_key, :api_token, :api_signature, :api_receipt].each do |prop|
    it "should make #{prop} accessible as a method when set as a parameter" do
      req = fake_request(:query_string=>"#{MerbAuthSliceFullfat[:"#{prop}_param"]}=value_for_#{prop}")
      req.send(prop).should == "value_for_#{prop}"
    end
  end  
  
end