require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::Token do

  before :each do
    @authenticating_clients = 3.of {MerbAuthSliceFullfat::AuthenticatingClient.gen}
    @users = 3.of {user_class.gen}
    @date = DateTime.civil(2009)
  end

  it "should be creatable as a receipt for an application" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date)
    a.expires.should == @date
    a.authenticating_client.should == @authenticating_clients.first
    a.token.should be_nil
    a.user.should be_nil
    a.should be_valid
  end
  it "should be creatable as a reciept for an application and user" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.user_id.should == @users.first.id
    a.user.should == @users.first
    a.authenticating_client.should == @authenticating_clients.first
    a.receipt.should match(/[a-zA-Z0-9]{10}/)
    a.should be_valid
  end

  it "should generate a unique receipt upon creation" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date)
    a.receipt.should match(/[a-zA-Z0-9]{10}/)
  end
  it "should not be saveable without being related to an application that exists" do
    a = MerbAuthSliceFullfat::Token.create_receipt(nil, @date, @users.first)
    a.new_record?.should be_true
    a.errors.length.should == 1
    a.errors[:authenticating_client].should_not be_nil
  end
  it "should generate a unique token and apply the given expiry upon activation" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @users.first)
    result = a.activate!
    a.should be_valid
    result.should be_true
    a.token.should match(/[a-zA-Z0-9]{10}/)
    a.activated?.should be_true
  end
  it "should not activate if no user has been specified" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date)
    a.activate!.should be_false
    a.token.should be_nil
    a.activated?.should be_false
  end
  
  it "should not change receipt code on save if one was already set" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.new_record?.should be_false
    r = a.receipt
    a.save
    a.receipt.should == r
  end
  it "should not change token code on save if one was already set" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.new_record?.should be_false
    a.activate!.should be_true
    t = a.token
    a.save
    a.token.should == t
  end
  
  it "should determine if the object is editable by a given user" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.editable_by_user?(@users.first).should be_true
    a.editable_by_user?(user_class.gen).should be_false
  end
  
  it "should return default permissions if permissions are not set" do
    a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @users.first)
    MerbAuthSliceFullfat[:default_permissions].should_not be_nil
    a.permissions = nil
    a.permissions.should == MerbAuthSliceFullfat[:default_permissions]
    a.permissions = "delete"
    a.permissions.should == "delete"
  end
  
  describe "#authenticate!" do
    before :each do
      @user = user_class.gen
      @a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @user)
      @a.activate!.should be_true
    end
    
    it "should not authenticate a user when given an incorrect API key and a correct token" do      
      MerbAuthSliceFullfat::Token.authenticate!("DSFARGEG", @a.token).should be_false
    end
    it "should not authenticate a user when given a correct API key and the receipt as a token" do
      MerbAuthSliceFullfat::Token.authenticate!(@authenticating_clients.first.api_key, @a.receipt).should be_false
    end
    it "should not authenticate a user when given a correct API key but an incorrect token" do
      MerbAuthSliceFullfat::Token.authenticate!(@authenticating_clients.first.api_key, "DSFARGEG").should be_false
    end
    it "should authenticate a user when given a correct API key and a correct token" do
      #@a.user_id.should == ""
      MerbAuthSliceFullfat::Token.authenticate!(@authenticating_clients.first.api_key, @a.token).should == @user
    end
  end
  
  describe "transformations" do
    before :each do
      @user = user_class.gen
      @a = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_clients.first, @date, @user)
    end
    
    it "should transform as a 'receipt' bundle when not activated" do
      @a.activated?.should be_false
      @a.to_xml.should contain(@a.receipt)
      @a.to_json.should contain(@a.receipt)
      @a.to_json.should contain("receipt")
      @a.to_yaml.should contain(@a.receipt)
      @a.to_yaml.should contain("receipt")      
    end
    it "should transform as a 'token' bundle when activated" do
      @a.activate!.should be_true
      @a.token.should match(/[0-9A-Za-z]{10}/)
      @a.to_xml.should contain(@a.token)
      @a.to_json.should contain(@a.token)
      @a.to_json.should contain("token")
      @a.to_yaml.should contain(@a.token)
      @a.to_yaml.should contain("token")
    end
  end 
  
end