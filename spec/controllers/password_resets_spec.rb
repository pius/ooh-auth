require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe MerbAuthSliceFullfat::PasswordResets do
  
  before :all do
    Merb::Router.prepare do 
      add_slice(:MerbAuthSliceFullfat)
      match("/secrets").to(:controller=>"merb_auth_slice_fullfat/secrets", :action=>"index").name(:secrets)
    end if standalone?
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :index)
    @prefix = MerbAuthSliceFullfat[:path_prefix]
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  after(:each) do
    user_class.all.destroy!
    MerbAuthSliceFullfat::PasswordReset.all.destroy!
  end

  it "should have resource-type routing keyed by identifier" do
    pwr = MerbAuthSliceFullfat::PasswordReset.gen    
    @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :index)    
    @controller.slice_url(:password_resets).should      == "/#{@prefix}/password_resets"
    @controller.slice_url(:password_reset, pwr).should  == "/#{@prefix}/password_resets/#{pwr.identifier}"
  end

  describe "new/create action" do    
    it "should render a password reset form" do
      @controller = get(@controller.slice_url(:new_password_reset))
      @controller.status.should == 200
      @controller.action_name.should == "new"
    end
    it "should display the form with a message when given an incorrect identifier" do
      @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :create, password_reset_identifier_field=>"DSFARGEG")
      @controller.status.should == 404
      @controller.message.length.should > 10
      noko(@controller.body).css("form").length.should == 1
    end

    it "should successfully create a new reset when given a correct identifier" do
      user = user_class.gen
      @controller = dispatch_to(
        MerbAuthSliceFullfat::PasswordResets, 
        :create, 
        password_reset_identifier_field=>user.send(password_reset_identifier_field)
      )
      @controller.status.should == 201
      @controller.headers['Location'].should == @controller.slice_url(:password_reset, @controller.assigns(:password_reset))
    end
  end
  
  describe "show action" do
    before :each do
      @user = user_class.gen
      @pwr = MerbAuthSliceFullfat::PasswordReset.create_for_user(@user)
    end
    
    it "should be showable given the correct identifier" do
      @controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :show, :identifier=>@pwr.identifier)
      @controller.status.should == 200
      @controller.should be_successful
    end
    it "should raise NotFound when a bad identifier is given" do
      lambda {@controller = dispatch_to(MerbAuthSliceFullfat::PasswordResets, :show, :identifier=>"MONGOOSE")}.
      should raise_error(Merb::Controller::NotFound)
    end
  end
  
  describe "edit/update" do  
    before :each do
      @user = user_class.gen
      @pwr = MerbAuthSliceFullfat::PasswordReset.create_for_user(@user)
    end
    it "should render the form with a message and make no changes when a bad secret is entered" do
      @controller = dispatch_to(
                      MerbAuthSliceFullfat::PasswordResets, :update, 
                      {
                        :identifier=>@pwr.identifier, :secret=>"blaaaaaaaah",
                        :password=>"good_password", :password_confirmation=>"good_password"
                      }
                    )
      @controller.status.should == 406
      noko(@controller.body).css("#_message").length.should == 1
      user_class.authenticate(user_class.login, "good_password").should be_nil
    end
    it "should render the form with a message and make no changes when a good secret is entered but the password and confirmation do not match" do
      @controller = dispatch_to(
                      MerbAuthSliceFullfat::PasswordResets, :update, 
                      {
                        :identifier=>@pwr.identifier, :secret=>@pwr.secret,
                        :password=>"good_password", :password_confirmation=>"good_password_but_not_that_good"
                      }
                    )
      @controller.status.should == 406
      noko(@controller.body).css("#_message").length.should == 1
      user_class.authenticate(user_class.login, "good_password").should be_nil
      user_class.authenticate(user_class.login, "good_password_but_not_that_good").should be_nil
    end
    it "should successfully reset the user's pass when the correct key is posted to update and the password and confirmation both match" do
      @controller = dispatch_to(
                      MerbAuthSliceFullfat::PasswordResets, :update, 
                      {
                        :identifier=>@pwr.identifier, :secret=>@pwr.secret,
                        :password=>"changed_password_this_time", :password_confirmation=>"changed_password_this_time"
                      }
                    )
      @controller.status.should == 200
      user_class.authenticate(user_class.login, "changed_password_this_time").should be_kind_of(user_class)
      noko(@controller.body).css("form.session").length.should == 1    
    end
    it "should destroy the password reset on successful consumption"
  end
  
  it "should return the user to the host application once a reset is claimed"
  it "should allow cancellation of a passwordreset using the destroy action"
  
end