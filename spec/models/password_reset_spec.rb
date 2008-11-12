require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::PasswordReset do
  
  before(:each) do
    user_class.all.destroy!
    MerbAuthSliceFullfat::PasswordReset.all.destroy!
  end
  
  after(:each) do
    user_class.all.destroy!
    MerbAuthSliceFullfat::PasswordReset.all.destroy!
  end

  it "should be able to find by identifier" do
    @password_reset = MerbAuthSliceFullfat::PasswordReset.gen(:identifier=>"DSFARGEG")
    MerbAuthSliceFullfat::PasswordReset.find_by_identifier("DSFARGEG").should be_kind_of(MerbAuthSliceFullfat::PasswordReset)
    MerbAuthSliceFullfat::PasswordReset.find_by_identifier("DSFARGEGGGG").should be_nil
  end
  
  it "should return a blank unsaved object if the given argument to create_for_user evals to false" do
    pw_count = MerbAuthSliceFullfat::PasswordReset.count
    pw = MerbAuthSliceFullfat::PasswordReset.create_for_user(nil)
    pw.new_record?.should be_true
    pw.user_id.should be_nil
    pw_count.should == MerbAuthSliceFullfat::PasswordReset.count
  end
  
  it "should return a saved object with a foreign identifier set when create_for_user is called with a user object" do
    pw_count = MerbAuthSliceFullfat::PasswordReset.count
    user = user_class.gen
    pw = MerbAuthSliceFullfat::PasswordReset.create_for_user(user)
    pw.user_id.should == user.id
    pw.new_record?.should be_false
    (pw_count + 1).should == MerbAuthSliceFullfat::PasswordReset.count
  end
  
  it "should generate a passphrase and a identifier upon creation" do
    password_resets = 20.of {MerbAuthSliceFullfat::PasswordReset.gen(:identifier=>nil, :secret=>nil)}
    identifiers = password_resets.collect{|pw| pw.identifier}
    identifiers.uniq.length.should == password_resets.length
    
    password_resets.first.secret.should match(/(\w+\s)+/)
    password_resets.first.identifier.should match(/[a-zA-Z0-9]+/)
  end
  
  it "should destroy older results for the same user upon creation" do
    user = user_class.gen
    5.of {MerbAuthSliceFullfat::PasswordReset.gen(:user_id=>user.id)}
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>user.id).size.should == 1
    5.of {MerbAuthSliceFullfat::PasswordReset.gen(:user_id=>user.id)}
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>user.id).size.should == 1
    5.of {MerbAuthSliceFullfat::PasswordReset.gen(:user_id=>123456)}
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>123456).size.should == 1
    MerbAuthSliceFullfat::PasswordReset.all(:user_id=>user.id).size.should == 1
  end
  
  describe "created for a user" do
    before(:each) do
      @user = user_class.gen
      @reset = MerbAuthSliceFullfat::PasswordReset.create_for_user(@user)
    end
      
    it "should change the user's password when consumed" do
      old_password = @user.password
      @new_user = @reset.consume!("changed_password", "changed_password")
      @new_user.password.should_not == old_password
      @authenticated_user = user_class.authenticate(@user.login, "changed_password")
      @authenticated_user.should be_kind_of(user_class)
    end
  
    it "should return the user with validation errors if the password confirmation does not match the given password" do
      pw_count = MerbAuthSliceFullfat::PasswordReset.count
      old_password = @user.password
      @new_user = @reset.consume!("changed_password", "different_password")
      pw_count.should == MerbAuthSliceFullfat::PasswordReset.count
      @new_user.should_not be_valid      
      @authenticated_user = user_class.authenticate(@user.login, "#{@user.login}_goodpass")
      @authenticated_user.should be_kind_of(user_class)
    end
    
    it "should destroy itself when consumed if the user was saved" do
      pw_count = MerbAuthSliceFullfat::PasswordReset.count
      user_count = user_class.count
      @new_user = @reset.consume!("changed_password", "changed_password")
      (pw_count - 1).should == MerbAuthSliceFullfat::PasswordReset.count
      user_count.should == user_class.count
    end
  end

end