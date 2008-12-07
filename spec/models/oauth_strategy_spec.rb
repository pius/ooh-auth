require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Merb::Authentication::Strategies::OAuth do
  
  before :all do
    # Create a client and a user, and authorise the client against the user by creating a token
    @authenticating_client = OohAuth::AuthenticatingClient.gen
    @user = user_class.gen
    @access = OohAuth::Token.create_request_key(@authenticating_client, 1.hour.since)
    @access.activate!(@user).should be_true
    @request = OohAuth::Token.create_request_key(@authenticating_client, 1.hour.since)
    @request.activated?.should be_false
    
    Merb::Router.prepare do 
      add_slice(:OohAuth)
      match("/secrets").to(:controller=>"ooh_auth/secrets", :action=>"index").name(:secrets)
    end if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should not authenticate with an unsigned request even if the given token is correct" do
    request = fake_request(:request_uri=>"/secrets", :query_string=>"oauth_token=#{@access.token_key}&oauth_consumer_key=#{@authenticating_client.api_key}")
    request.authentication_token.activated?.should be_true
    request.consumer_key.should == @authenticating_client.api_key
    request.token.should == @access.token_key
    strat = Merb::Authentication::Strategies::OAuth.new(request, {})
    strat.run!.should be_nil
  end
  it "should authenticate a signed request with a valid token" do
    request = request_signed_by(@authenticating_client, {:oauth_token=>@access.token_key, :other_param=>"CHEEESE"})
    request.authentication_token.activated?.should be_true
    request.consumer_key.should == @authenticating_client.api_key
    request.token.should == @access.token_key
    strat = Merb::Authentication::Strategies::OAuth.new(request, {})
    strat.run!.should == @user
  end
  it "should not authenticate a signed request with an expired token"
  it "should not authenticate a signed request with a receipt but no token" do
    request = request_signed_by(@authenticating_client, {:oauth_token=>@request.token_key})
    request.authentication_token.activated?.should be_false
    strat = Merb::Authentication::Strategies::OAuth.new(request, {})
    strat.run!.should be_nil
  end
  
end