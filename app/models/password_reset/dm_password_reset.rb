class MerbAuthSliceFullfat::PasswordReset
  include DataMapper::Resource
  
  @@user_class = Merb::Authentication.user_class
  
  property :id, Serial              # internal ID
  property :key, String             # long alphanumeric key used to identify this object in urls
  property :passphrase, String      # passphrase required to change the password, only present in the sent email
  property :created_at, DateTime    # timestamp for validity checking
  property :user_id, Integer        # probably need this to like, relate the object to a user or something. ymmv.
  
  # A password reset is a small token with a long alphanumeric passphrase associated with it.
  # An unauthenticated user may consume a PasswordReset in order to change their password.
  # Important behavioural details:
  # - Creating a new password reset for a user will destroy all prior resets for that user.
  # - Creation and consumption of these objects drives the generation of user password mail.
    
  # Common Interface - MUST be provided by all versions of this class for all ORMs.
  # ------------------------------------------------------------------------------------------------
    
  # Finds the most recent valid PasswordReset for the given user.
  def self.find_by_key(k)
    first(:key => k)
  end
  
  # Creates a new reset for the given user.
  # Returns a blank unsaved object if the given argument is nil.
  def self.create_for_user(u)
    return new if !u or u.new_record?
    create :user_id=>u.id
  end
  
  # Consumes the reset given a new password
  def consume!(password)
    
  end  
  
  # Internal functionality
  # ------------------------------------------------------------------------------------------------
  
  before :save, :clear_history_if_new
  def clear_history_if_new
    self.class.all(:user_id=>user_id).destroy! if new_record?
  end
  
  before :save, :generate_keys_if_new
  def generate_keys_if_new
    if new_record?
      while(key.nil? or passphrase.nil? or self.class.find_by_key(key)) do
        self.key = MerbAuthSliceFullfat::KeyGenerators::Alphanum.new(30)
        self.passphrase = MerbAuthSliceFullfat::KeyGenerators::Passphrase.new(4)
      end
    end
  end

end