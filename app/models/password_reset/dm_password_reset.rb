class MerbAuthSliceFullfat::PasswordReset
  include DataMapper::Resource
  
  property :id,           Serial      # internal ID
  property :identifier,   String      # long alphanumeric identifier used to identify this object in urls
  property :secret,       String      # secret required to change the password, only present in the sent email
  property :created_at,   DateTime    # timestamp for validity checking
  property :user_id,      Integer     # probably need this to like, relate the object to a user or something. ymmv.
  
  validates_present :user_id
  
  # A password reset is a small token with a long alphanumeric secret associated with it.
  # An unauthenticated user may consume a PasswordReset in order to change their password.
  # Important behavioural details:
  # - Creating a new password reset for a user will destroy all prior resets for that user.
  # - Creation and consumption of these objects drives the generation of user password mail.
    
  # Common Interface - MUST be provided by all versions of this class for all ORMs.
  # ------------------------------------------------------------------------------------------------
    
  # Finds the most recent valid PasswordReset for the given user.
  def self.find_by_identifier(k)
    o=first(:identifier => k)
  end
  
  # Creates a new reset for the given user.
  # Returns a blank unsaved object if the given argument is nil.
  def self.create_for_user(u)
    u = u.id if u.is_a?(user_class)
    create :user_id=>u
  end
  
  # Consumes the reset given a new password and confirmation
  # Returns the user with the changed password having attempted to save the user record.
  # Deletes self if the save is successful
  def consume!(password, password_confirmation=nil)
    @user = user_class.get(user_id) unless @user
    @user.password = password; @user.password_confirmation = password_confirmation
    self.destroy if @user.save
    return @user
  end  
  
  # Internal functionality
  # ------------------------------------------------------------------------------------------------
  
  before :save, :clear_history_if_new
  def clear_history_if_new
    self.class.all(:user_id=>user_id).destroy! if new_record?
  end
  
  before :save, :generate_identifiers_if_new
  def generate_identifiers_if_new
    if new_record?
      while(identifier.nil? or secret.nil? or self.class.find_by_identifier(identifier)) do
        self.identifier = MerbAuthSliceFullfat::KeyGenerators::Alphanum.gen(30)
        self.secret = MerbAuthSliceFullfat::KeyGenerators::Passphrase.gen(5)
      end
    end
  end
  
  def user_class; self.class.user_class; end
  def self.user_class; Merb::Authentication.user_class; end

end