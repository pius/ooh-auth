class MerbAuthSliceFullfat::PasswordReset
  include DataMapper::Resource
  
  @@user_class = Merb::Authentication.user_class
  
  property :id, Serial
  property :passphrase, String
  property :created_at, DateTime
  property :user_id, Integer
  
  # A password reset is a small token with a long alphanumeric passphrase associated with it.
  # An unauthenticated user may consume a PasswordReset in order to change their password.
  # Important behavioural details:
  # - Creating a new password reset for a user will destroy all prior resets for that user.
    before :save, :"set_unique_passphrase!"
  # - Creation and consumption of these objects drives the generation of user password mail.
    after :save,    :mail_link
    after :destroy, :mail_new_password
    
  # Common Interface - MUST be provided by all versions of this class for all ORMs.
  # ------------------------------------------------------------------------------------------------
    
  # Finds the most recent valid PasswordReset for the given user.
  def self.find_by_passphrase(p)
    self.first(:passphrase => p)
  end
  
  # Creates a new reset for the given user.
  def self.new_for_user(u)
    create :user_id=>u.id
  end
  
  # Consumes the reset given a new password
  def consume!(password)
    
  end  
  
  # Internal functionality
  # ------------------------------------------------------------------------------------------------

  

end