require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe PasswordReset do

  #before(:each) do
  #  @user = User.gen
  #  @pwr = PasswordReset.gen(:user=>@user)
  #end
  #
  #it "should have be able to find by passphrase" do
  #  reset = PasswordReset.gen(:user=>@user, :passphrase=>"known_passphrase")
  #  pr = PasswordReset.find_by_passphrase("known_passphrase")
  #  pr.should be_a(PasswordReset)
  #end
  #
  #it "should not return results for nonexistant passphrases" do
  #  pr = PasswordReset.find_by_passphrase("doesn't exist")
  #  pr.should be_nil
  #end
  #
  #it "should generate a passphrase if none was given" do
  #  reset = PasswordReset.gen(:user=>@user, :passphrase=>nil)
  #  reset.passphrase.should_not be_nil
  #  reset.passphrase.should be_a(String)
  #  (reset.passphrase.length > 10).should be_true
  #end

end