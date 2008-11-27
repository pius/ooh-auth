require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe MerbAuthSliceFullfat::Request::VerificationMixin do
  
  it "should verify that a correctly-signed request is signed"
  it "should include the full URI used, including a trailing slash if given"
  it "should fail if parameters are serialised in the wrong order"
  
end