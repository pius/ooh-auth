require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuthSliceRestful (module)" do
  
  before :all do
    Merb::Router.prepare { all_slices } if standalone?
  end
   
  after :all do
    Merb::Router.reset! if standalone?
  end
  
end