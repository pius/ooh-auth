require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::PasswordReset do
  
  
  before(:each) do
    @password_resets = 10.of {MerbAuthSliceFullfat::PasswordReset.gen}
  end

  it "should be able to find by key" do
    @password_reset = MerbAuthSliceFullfat::PasswordReset.gen(:key=>"DSFARGEG")
    MerbAuthSliceFullfat::PasswordReset.find_by_key("DSFARGEG").should be_kind_of(MerbAuthSliceFullfat::PasswordReset)
    MerbAuthSliceFullfat::PasswordReset.find_by_key("DSFARGEGGGG").should be_nil
  end
  
  it "should return a blank unsaved object if the given argument to create_for_user evals to false" do
    pw_count = MerbAuthSliceFullfat::PasswordReset.count
    pw = MerbAuthSliceFullfat::PasswordReset.create_for_user(nil)
    pw.new_record?.should be_true
    pw.user_id.should be_nil
    pw_count.should == MerbAuthSliceFullfat::PasswordReset.count
  end
  
  it "should return a saved object with a foreign key set when create_for_user is called with a user object" do
    pw_count = MerbAuthSliceFullfat::PasswordReset.count
    user = user_class.new
    pw = MerbAuthSliceFullfat::PasswordReset.create_for_user(user)
    pw.user_id.should == user.id
    pw.new_record?.should be_false
    (pw_count + 1).should == MerbAuthSliceFullfat::PasswordReset.count
  end
  
  it "should not return results for nonexistant passphrases"
  it "should generate a passphrase if none was given upon creation"
  it "should destroy older results for the same user upon creation" do
    user = user_class.new
    user.save
    5.of {MerbAuthSliceFullfat::PasswordReset.gen(:user_id=>user.id)}
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>user.id).size.should == 1
    5.of {MerbAuthSliceFullfat::PasswordReset.gen(:user_id=>user.id)}
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>user.id).size.should == 1
    5.of {MerbAuthSliceFullfat::PasswordReset.gen(:user_id=>123456)}
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>123456).size.should == 1
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>user.id).size.should == 1
  end
  it "should be destroyable without resetting the user's password"
  it "should destroy itself when consumed"

end