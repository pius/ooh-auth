require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::PasswordReset do

  it "should have be able to find by passphrase"
  it "should not return results for nonexistant passphrases"
  it "should generate a passphrase if none was given"
  it "should destroy older results for the same user upon creation"
  it "should be destroyable without resetting the user's password"
  it "should destroy itself when consumed"

end