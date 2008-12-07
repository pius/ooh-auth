require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe OohAuth::Tokens do

  before :each do
    @user = user_class.gen
    @authenticating_client =        OohAuth::AuthenticatingClient.gen
    @other_authenticating_client =  OohAuth::AuthenticatingClient.gen
    @receipt =                      OohAuth::Token.create_request_key(@authenticating_client, 1.hour.since)
    @token =                        OohAuth::Token.create_request_key(@authenticating_client, 1.hour.since)
    @token.activate!(@user)
    @bad_receipt =                  OohAuth::Token.create_request_key(@other_authenticating_client, 1.hour.since)
    @controller =                   dispatch_to(OohAuth::Public, :index)
  end
  
  before :all do
    Merb::Router.prepare do 
      add_slice(:OohAuth)
    end if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end

  describe "index action" do
    %w(js yaml xml html).each do |format|
      it "#{format} requests should generate an anonymous receipt when sent GET with a consumer and no other information." do
        @controller = get(sign_url_with(@authenticating_client, @controller.slice_url(:tokens), :format=>format))
        @controller.should be_successful
        request_token = @controller.assigns(:token)
        request_token.should be_kind_of(OohAuth::Token)
        request_token.activated?.should be_false
        request_token.new_record?.should be_false
      end
    end
    
    it "should return OAuth-format key responses if no format is specified" do
      @controller = get(sign_url_with(@authenticating_client, @controller.slice_url(:tokens)))
      request_token = @controller.assigns(:token)
      @controller.body.should == "oauth_token=#{request_token.token_key}&oauth_token_secret=#{request_token.secret}"
    end
  
    it "should generate nothing and return a 406 not acceptable when the request is not signed or contains an incorrect API key" do
      lambda {get(@controller.slice_url(:tokens, :oauth_consumer_key=>@authenticating_client.api_key))}.should raise_error(Merb::Controller::NotAcceptable)
    end

    it "should generate an authorised access key when sent GET with a consumer key and unauthorized request key when the request key is activated." do
      @controller = OohAuth::Tokens.new(
        request_signed_by(@authenticating_client, {:oauth_token=>@token.token_key}, {}, {:request_uri=>@controller.slice_url(:tokens)})
      )
      @controller.index
      @controller.should be_successful
      auth = @controller.assigns(:token)
      auth.should be_kind_of(OohAuth::Token)
      auth.activated?.should be_true
    end
    it "should not generate an auth token if the given token does not belong to the given application" do
      @controller = OohAuth::Tokens.new(
        request_signed_by(@authenticating_client, {:oauth_token=>@bad_receipt.token_key}, {}, {:request_uri=>@controller.slice_url(:tokens)})
      )
      lambda {@controller.index}.should raise_error(Merb::Controller::NotAcceptable)
    end
  end

  
  describe "new action" do
    before :all  do
      @user =         user_class.gen
      @desktop_app =  OohAuth::AuthenticatingClient.gen(:kind=>"desktop")
      @request_key =  OohAuth::Token.create_request_key(@desktop_app, 1.hour.since)
    end
    
    it "should require a login" do
      lambda {@controller = get(sign_url_with(@desktop_app, @controller.slice_url(:new_token), :oauth_token=>@request_key.token_key)) }.
      should raise_error(Merb::Controller::Unauthenticated)
    end
    
    it "should display a form to the user and locate the correct receipt from the database on GET" do
      request = fake_request(:query_string=>"oauth_token=#{@request_key.token_key}&oauth_callback=http://www.feesh.com/index.php")
      request.session.user = @user
      @controller = OohAuth::Tokens.new(request)
      doc = @controller.new
      @controller.should be_successful
      @controller.assigns(:authenticating_client).should == @desktop_app
      @controller.assigns(:token).activated?.should be_false
      doc.should contain(@controller.assigns(:authenticating_client).name)
    end
    it "should display nothing and return a 406 when the params contain an request key which is invalid" do
      lambda do 
        @controller = get(sign_url_with(@authenticating_client, @controller.slice_url(:new_token), :oauth_consumer_key=>"DIDDLYSQUAT"))
      end.should raise_error(Merb::Controller::NotAcceptable)
    end
    it "should raise unauthenticated when a client attempts to render the page using oauth credentials" do
      @token.activated?.should be_true
      @token.authenticating_client.should == @authenticating_client
      lambda do 
        @controller = get(sign_url_with(@authenticating_client, @controller.slice_url(:new_token), :oauth_token=>@token.token_key))
      end.should raise_error(Merb::Controller::Unauthenticated)
    end
  end
  
  describe "create action" do
    before :each  do
      @user =         user_class.gen
      @desktop_app =  OohAuth::AuthenticatingClient.gen(:kind=>"desktop")
      @request_key =  OohAuth::Token.create_request_key(@desktop_app, 1.hour.since)
      @access_key =   OohAuth::Token.create_request_key(@desktop_app, 1.hour.since)
      @access_key.activate!(@user)
      @date =         Date.today + 5.years
    end
    
    it "should not activate a valid request token when any button other than 'allow' was clicked to submit the auth form" do
      request = fake_request({}, {:post_body=>"oauth_token=#{@request_key.token_key}&commit=deny&"})
      request.session.user = @user
      @controller = OohAuth::Tokens.new(request)
      response = @controller.create({})
      auth = @controller.assigns(:token)
      auth.user.should be_nil
      auth.activated?.should be_false
      response.should contain("You denied")
    end
    it "should activate a request token on POST when the 'allow' button was clicked to submit the auth form" do
      request = fake_request({}, {:post_body=>"oauth_token=#{@request_key.token_key}&commit=allow&"})
      request.session.user = @user
      @controller = OohAuth::Tokens.new(request)
      response = @controller.create({:expires=>@date.strftime("%Y-%m-%d"), :permissions=>"delete"})
      auth = @controller.assigns(:token)
      auth.user.should == @user
      auth.authenticating_client.should == @desktop_app
      auth.expires.should >= Date.today + 4.years + 364.days
      auth.expires.should <= Date.today + 5.years + 1.days
      auth.activated?.should be_true
      response.should contain("You successfully authorized")
    end
    it "should redirect to the callback URL on successful activation if a callback url is given, appending oauth_token to the callback URL's parameters" do
      request = fake_request({}, {:post_body=>"oauth_token=#{@request_key.token_key}&commit=allow&oauth_callback=#{Merb::Parse.escape("http://www.test.com/noflags")}"})
      request.session.user = @user
      @controller = OohAuth::Tokens.new(request)
      response = @controller.create({})
      @controller.assigns(:token).activated?.should be_true
      @controller.should redirect_to("http://www.test.com/noflags?oauth_token=#{@controller.assigns(:token).token_key}")
    end
    it "should gracefully handle existing GET parameters on the callback url" do
      request = fake_request({}, {:post_body=>"oauth_token=#{@request_key.token_key}&commit=allow&oauth_callback=#{Merb::Parse.escape("http://www.test.com/flags?foo=bar")}"})
      request.session.user = @user
      @controller = OohAuth::Tokens.new(request)
      response = @controller.create({})
      @controller.assigns(:token).activated?.should be_true
      @controller.should redirect_to("http://www.test.com/flags?foo=bar&oauth_token=#{@controller.assigns(:token).token_key}")
    end
  
    it "should require a user to be logged in via session" do
      lambda do 
        @controller = post(sign_url_with(@authenticating_client, @controller.slice_url(:new_token), :oauth_token=>@access_key.token_key))
      end.should raise_error(Merb::Controller::Unauthenticated)
    end
  end
  #
  #describe "edit/update action" do
  #  it "should only be accessible by the token's owning user"
  #  it "should return 404 not found for other users"
  #  it "should only allow the expiry and permission level to be altered"
  #end
  #
  #describe "delete/destroy action" do
  #  it "should only be accessible by the token's owning user"
  #  it "should return a 404 not found for other users"
  #  it "should remove all authentications for this user/application if multiple records are present"
  #end
  
end