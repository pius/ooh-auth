require File.join( File.dirname(__FILE__), '..', "spec_helper" )
require 'digest/sha1'

describe MerbAuthSliceFullfat::Request::VerificationMixin do
  
  before :all do
    # set the api key to a known value for the purposes of this test suite
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen(:api_key=>"fishsticks")
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
      match("/secrets").to(:controller=>"merb_auth_slice_fullfat/secrets", :action=>"index").name(:secrets)
    end if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should be included in the Merb::Request and FakeRequest classes on slice initialisation" do
    Merb::Request.include?(MerbAuthSliceFullfat::Request::VerificationMixin).should be_true
    Merb::Test::RequestHelper::FakeRequest.include?(MerbAuthSliceFullfat::Request::VerificationMixin).should be_true
  end
  
  #it "should verify that a correctly-signed GET request is signed using GET parameters" do
  #  req = request_signed_by(
  #    @authenticating_client, 
  #    { :a=>"1", :b=>"3", :c=>"2"}
  #  )
  #  req.method.should == :get
  #  req.authenticating_client.should == @authenticating_client
  #  req.signed?.should be_true
  #end
  #
  #it "should include POST parameters when signing POST requests" do
  #  req = request_signed_by(
  #    @authenticating_client, 
  #    { :a=>"1", :b=>"3", :c=>"2"},
  #    { :post_me => "a_var" },
  #    {:request_method=>"POST"}
  #  )
  #  req.method.should == :post
  #  req.authenticating_client.should == @authenticating_client
  #  req.signed?.should be_true    
  #end
  #it "should fail to verify that a request is signed if the signature is in any way wrong" do
  #  get_params = {
  #    :a=>"1", 
  #    :api_key=>"fishsticks",
  #    :api_signature=>"I R HACKIN YOO LOL"
  #  }
  #  param_string = get_params.collect{|k,v| "#{k}=#{v}"}.join("&")
  #  req = fake_request(
  #    :query_string => param_string, 
  #    :http_host => "test.fullfat.com", 
  #    :request_uri=>"/secrets/"
  #  )
  #  req.authenticating_client.should == @authenticating_client
  #  req.signed?.should be_false
  #end
  
  it "should include OAuth HTTP headers in the signature"
  it "should successfully parse OAuth HTTP headers" do
    # Make a real nasty header example with carriage returns and other gremlins
    oauth_headers = "OAuth realm=\"FOO\", foo=\"bar\",
                     bar=\"baz\""
    req = fake_request("Authorization"=>oauth_headers)
    req.env["AUTHORIZATION"].should == oauth_headers
    req.oauth_headers.should == {:realm=>"FOO", :foo=>"bar", :bar=>"baz"}
  end
  it "should remove the OAuth realm from the signature headers" do
    # Make a real nasty header example with carriage returns and other gremlins
    req = fake_request(:request_uri=>"/secrets", "Authorization"=>"OAuth realm=\"FOO\", foo=\"bar\", bar=\"baz\"")
    req.signature_oauth_headers.should == {:foo=>"bar", :bar=>"baz"}
    req.oauth_headers.should == {:realm=>"FOO", :foo=>"bar", :bar=>"baz"}    
  end
  it "should merge POST/GET params into auth header params, giving auth header params priority" do
    req = fake_request(:request_uri=>"/secrets", "Authorization"=>"OAuth realm=\"FOO\", foo=\"bar\", bar=\"baz\", overridden=\"no\"", :query_string=>"get=yes&overridden=yes")
    req.normalise_signature_params.should == "bar=baz&foo=bar&get=yes&overridden=no"
  end
  it "should properly construct the baseline signature string" do
    req = fake_request(:http_host=>"test.fullfat.com", :request_uri=>"/secrets", "Authorization"=>"OAuth realm=\"FOO\", foo=\"bar\", bar=\"baz\", overridden=\"no\"", :query_string=>"get=yes&overridden=yes")
    req.signature_base_string.should == "GET&http://test.fullfat.com/secrets&bar=baz&foo=bar&get=yes&overridden=no"
  end
  it "should properly compare the encrypted signature strings when a valid consumer key is given" do
    req = fake_request(:http_host=>"test.fullfat.com", :request_uri=>"/secrets", "Authorization"=>"OAuth realm=\"FOO\", oauth_consumer_key=\"#{@authenticating_client.api_key}\", foo=\"bar\", bar=\"baz\", overridden=\"no\"", :query_string=>"get=yes&overridden=yes")
    req.authenticating_client.should == @authenticating_client
    req.signed?.should be_false
  end
  it "should merge OAuth HTTP headers into the available params"  
  it "should recognise OAuth requests by the inclusion of the OAuth header"
  
  
end