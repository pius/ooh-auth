require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::Authentication do

  before :each do
    @authenticating_clients = 3.of {MerbAuthSliceFullfat::AuthenticatingClient.gen}
    @users = 3.of {user_class.gen}
    @date = DateTime.civil(2009)
  end

  it "should be creatable as a receipt for an application" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date)
    a.expires.should == @date
    a.authenticating_client.should == @authenticating_clients.first
    a.token.should be_nil
    a.user.should be_nil
    a.should be_valid
  end
  it "should be creatable as a reciept for an application and user" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.user_id.should == @users.first.id
    a.user.should == @users.first
    a.authenticating_client.should == @authenticating_clients.first
    a.receipt.should match(/[a-zA-Z0-9]{10}/)
    a.should be_valid
  end
  it "should only allow access to the token attribute once the application and user and receipt are set"

  it "should generate a unique receipt upon creation" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date)
    a.receipt.should match(/[a-zA-Z0-9]{10}/)
  end
  it "should not be saveable without being related to an application that exists" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(nil, @date, @users.first)
    a.new_record?.should be_true
    a.errors.length.should == 1
    a.errors[:authenticating_client].should_not be_nil
  end
  it "should generate a unique token and apply the given expiry upon activation" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date, @users.first)
    result = a.activate!
    a.should be_valid
    result.should be_true
    a.token.should match(/[a-zA-Z0-9]{10}/)
    a.activated?.should be_true
  end
  it "should not activate if no user has been specified" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date)
    a.activate!.should be_false
    a.token.should be_nil
    a.activated?.should be_false
  end
  
  it "should not change receipt code on save if one was already set" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.new_record?.should be_false
    r = a.receipt
    a.save
    a.receipt.should == r
  end
  it "should not change token code on save if one was already set" do
    a = MerbAuthSliceFullfat::Authentication.create_receipt(@authenticating_clients.first, @date, @users.first)
    a.new_record?.should be_false
    a.activate!.should be_true
    t = a.token
    a.save
    a.token.should == t
  end
  
  it "should not authenticate a user when given an incorrect API key and a correct token"
  it "should not authenticate a user when given a correct API key and the receipt as a token"
  it "should not authenticate a user when given a correct API key but an incorrect token"
  it "should authenticate a user when given a correct API key and a correct token"

end