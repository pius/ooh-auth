require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::AuthenticatingClient do

  before(:each) do
    MerbAuthSliceFullfat::AuthenticatingClient.all.destroy!
    @user = user_class.gen
    @authenticating_clients = 10.of {MerbAuthSliceFullfat::AuthenticatingClient.gen}
  end

  it "should generate a unique API key and a non-unique secret upon saving" do
    keys = []
    10.times do |i|
      @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen
      @authenticating_client.api_key = nil
      @authenticating_client.secret = nil
      @authenticating_client.save
      @authenticating_client.api_key.should be_kind_of(String)
      @authenticating_client.api_key.length.should >= 10
      keys << @authenticating_client.api_key
      keys.uniq.length.should == keys.length
      @authenticating_client.secret.length.should == 40
    end
  end
  
  it "should not change API keys when they are set" do
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.gen
    @authenticating_client.new_record?.should be_false
    @authenticating_client.name = "changed"
    ak = @authenticating_client.api_key
    ss = @authenticating_client.secret
    @authenticating_client.save.should be_true
    @authenticating_client.api_key.should == ak
    @authenticating_client.secret.should == ss
  end
  
  it "should auto-correct URLs given without protocol"
  it "should validate URL formats for homepage and icon URL"
  it "should not allow internal URLs to be given"

  it "should return an empty array when find_for_user is called with nil" do
    arr = MerbAuthSliceFullfat::AuthenticatingClient.find_for_user(nil)
    arr.length.should == 0
  end
  
  it "should return a list of authenticating clients when find_for_user is called with a valid user" do
    @authenticating_clients = 10.of {MerbAuthSliceFullfat::AuthenticatingClient.gen(:user_id=>@user.id)}
    arr = MerbAuthSliceFullfat::AuthenticatingClient.find_for_user(@user)
    arr.length.should == 10
  end

end