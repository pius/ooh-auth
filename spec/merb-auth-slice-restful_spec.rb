require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuthSliceRestful (module)" do
  
  # Implement your MerbAuthSliceRestful specs here
  
  it "should have proper specs"
  
  # To spec MerbAuthSliceRestful you need to hook it up to the router like this:
  
  before :all do
    Merb::Router.prepare { add_slice(:MerbAuthSliceRestful) } if standalone?
  end
   
  after :all do
    Merb::Router.reset! if standalone?
  end
  
end