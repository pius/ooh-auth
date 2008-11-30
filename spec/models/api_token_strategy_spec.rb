require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Merb::Authentication::Strategies::Basic::APIToken do
  
  before :all do
    # Create a client and a user, and authorise the client against the user by creating a token
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen
    @user = user_class.gen
    @authentication = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_client, 1.hour.since, @user)
    @authentication.activate!.should be_true
    
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
      match("/secrets").to(:controller=>"merb_auth_slice_fullfat/secrets", :action=>"index").name(:secrets)
    end if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should not authenticate with an unsigned request even if the given token is correct" do
    request = fake_request(:request_uri=>"/secret", :query_string=>"api_token=#{@authentication.token}&api_key=#{@authenticating_client.api_key}")
    request.api_token.should == @authentication.token
    request.api_key.should == @authenticating_client.api_key
    strat = Merb::Authentication::Strategies::Basic::APIToken.new(request, {})
    strat.run!.should be_nil
  end
  it "should authenticate a signed request with a valid token" do
    request = request_signed_by(@authenticating_client, {:api_token=>@authentication.token, :api_key=>@authenticating_client.api_key, :other_param=>"CHEEESE"})
    request.api_token.should == @authentication.token
    request.api_key.should == @authenticating_client.api_key
    strat = Merb::Authentication::Strategies::Basic::APIToken.new(request, {})
    strat.run!.should == @user
  end
  it "should not authenticate a signed request with an expired token"
  it "should not authenticate a signed request with a receipt but no token" do
    request = request_signed_by(@authenticating_client, {:api_receipt=>@authentication.receipt, :api_key=>@authenticating_client.api_key})
    request.api_token.should be_nil
    request.api_receipt.should == @authentication.receipt
    request.api_key.should == @authenticating_client.api_key
    strat = Merb::Authentication::Strategies::Basic::APIToken.new(request, {})
    strat.run!.should be_nil
  end
  
end