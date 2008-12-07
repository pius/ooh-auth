require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe OohAuth::Token do

  before :each do
    @authenticating_clients = 3.of {OohAuth::AuthenticatingClient.gen}
    @users = 3.of {user_class.gen}
    @date = DateTime.civil(2009)
  end

  it "should be creatable as a request key for an application" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    a.expires.should == @date
    a.authenticating_client.should == @authenticating_clients.first
    a.key.should_not be_blank
    a.user.should be_nil
    a.should be_valid
    a.activated?.should be_false
  end
  
  it "should generate a unique token_key upon creation" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    a.token_key.should match(/[a-zA-Z0-9]{10}/)
  end
  it "should generate a unique token and apply the given expiry upon activation" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    result = a.activate!(@users.first)
    a.should be_valid
    result.should be_true
    a.token_key.should match(/[a-zA-Z0-9]{10}/)
    a.activated?.should be_true
  end
  it "should not activate if no user has been specified" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    a.activate!(nil).should be_false
    a.activated?.should be_false
  end
  
  it "should not change token_key code on save if one was already set" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    a.new_record?.should be_false
    a.activate!(@users.first).should be_true
    t = a.token_key
    a.save
    a.token_key.should == t
  end
  
  it "should be findable with ::get_token" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    OohAuth::Token.get_token(a.token_key).should == a
  end
  
  it "should get a new key when activated" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    token = a.token_key
    token.should_not be_blank
    a.activate!(@users.first).should be_true
    a.token_key.should_not == token
    a.token_key.should_not be_blank
  end
  
  it "should generate a secret on first save" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    a.secret.should match(/[a-zA-Z0-9]{10}/)
  end
  it "should not change the secret on further saves" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    secret = a.secret
    a.expires = 1.year.since
    a.save.should be_true
    a.secret.should == secret
  end
  
  it "should determine if the object is editable by a given user" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    a.activate!(@users.first)
    a.editable_by_user?(@users.first).should be_true
    a.editable_by_user?(user_class.gen).should be_false
  end
  
  it "should return default permissions if permissions are not set" do
    a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
    OohAuth[:default_permissions].should_not be_nil
    a.permissions = nil
    a.permissions.should == OohAuth[:default_permissions]
    a.permissions = "delete"
    a.permissions.should == "delete"
  end
  
  describe "#authenticate!" do
    before :each do
      @user = user_class.gen
      @activated = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
      @activated.activate!(@user).should be_true
      @unactivated = OohAuth::Token.create_request_key(@authenticating_clients[1], @date)
    end
    
    it "should not authenticate a user when given an incorrect API key and an activated token_key" do      
      OohAuth::Token.authenticate!("DSFARGEG", @activated.token_key).should be_nil
    end
    it "should not authenticate a user when given a correct API key and an unactivated key token_key" do
      OohAuth::Token.authenticate!(@authenticating_clients.first.api_key, @unactivated.token_key).should be_nil
    end
    it "should not authenticate a user when given a correct API key but an incorrect token_key" do
      OohAuth::Token.authenticate!(@authenticating_clients.first.api_key, "DSFARGEG").should be_nil
    end
    it "should authenticate a user when given a correct API key and a correct, activated token_key" do
      #@a.user_id.should == ""
      OohAuth::Token.authenticate!(@authenticating_clients.first.api_key, @activated.token_key).should == @user
    end
  end
  
  describe "transformations" do
    before :each do
      @user = user_class.gen
      @a = OohAuth::Token.create_request_key(@authenticating_clients.first, @date)
      @a.new_record?.should be_false
    end
    
    it "should transform as a 'request_key' bundle when not activated" do
      @a.activated?.should be_false
      @a.to_xml.should contain(@a.token_key)
      @a.to_json.should contain(@a.token_key)
      @a.to_json.should contain("request_key")
      @a.to_yaml.should contain(@a.token_key)
      @a.to_yaml.should contain("request_key")      
    end
    it "should transform as a 'access_key' bundle when activated" do
      @a.activate!(@user).should be_true
      @a.token_key.should match(/[0-9A-Za-z]{10}/)
      @a.to_xml.should  contain(@a.token_key)
      @a.to_json.should contain(@a.token_key)
      @a.to_json.should contain("access_key")
      @a.to_yaml.should contain(@a.token_key)
      @a.to_yaml.should contain("access_key")
    end
  end 
  
end