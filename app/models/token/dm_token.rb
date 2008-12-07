=begin
 Token model
 
 A token is a stored authorisation allowing an authenticating client to:
 
  1. Get a *request key*. This is done by creating an unactivated token belonging to the authenticating client which has a _request key_.
  2. *Request access*. This is done by directing the user to a URL unique to the given request key, presenting them with a form.
     The user must be logged in through direct means in order to grant access.
  3. Getting an *access key* which is a property of the now-activated token.
  
=end

class MerbAuthSliceFullfat::Token
  include DataMapper::Resource
  
  property  :id,                        Serial
  property  :user_id,                   Integer,  :writer=>:protected
  property  :authenticating_client_id,  Integer,  :writer=>:protected
  
  # Expiry date will always be respected. You cannot authenticate using an expired token, and nor can you
  # convert an expired request key into an access key.
  property  :expires,       DateTime
  property  :created_at,    DateTime
  property  :permissions,   String
  
  property  :token_key,     String,   :writer=>:private, :index=>true
  property  :activated,     Boolean,  :writer=>:private, :index=>true, :default=>false
  property  :secret,        String,   :writer=>:private
  
  validates_is_unique     :token_key
  validates_present       :secret
  validates_present       :authenticating_client
  validates_with_method   :permissions, :permissions_valid?
  
  belongs_to :authenticating_client, :class_name=>"MerbAuthSliceFullfat::AuthenticatingClient", :child_key=>[:authenticating_client_id]
  belongs_to :user, :class_name=>Merb::Authentication.user_class.to_s, :child_key=>[:user_id]
  
  before :valid?, :create_token_key_if_not_present
  before :valid?, :create_secret_if_not_present
  
  # Authenticates a client on behalf of a user given the API parameters sent by the client
  # in the given API request. Returns the user on successful authentication, or false in
  # the event of a failure to authenticate. If the user was since deleted, NIL will be
  # returned.
  def self.authenticate!(consumer_key, access_key)
    auth = first('authenticating_client.api_key'=>consumer_key, :token_key=>access_key, :activated=>true, :expires.gt=>DateTime.now)
    return (auth)? auth.user : nil
  end
  
  # FIXME the relationship helper should be sorting this. Something to do with the variable class.
  def user
    Merb::Authentication.user_class.get(user_id)
  end
  
  # Tentatively create a request_key for a given client, not yet tied to a user.
  def self.create_request_key(authenticating_client, expires=1.hour.since)
    o = new(:authenticating_client=>authenticating_client, :expires=>expires)
    o.save or raise RuntimeError, "OAuth request key failed to save with errors: #{o.errors.inspect}"
    o
  end
  
  # Fetch a request_key given the request_key code
  def self.get_request_key_for_client(client, request_key)
    first :token_key=>request_key, :authenticating_client_id=>client.id, :expires.gt=>DateTime.now, :activated=>false
  end
  
  def self.get_token(token)
    first :token_key=>token
  end
  
  # Make this Authentication object active by generating an access key against it.
  # You may optionally specify a new expiry date/time for the access key.
  def activate!(with_user, expire_on=nil, permissions=nil)
    if authenticating_client and with_user
      self.activated = true
      self.expires = (expire_on || 1.year.since)
      self.permissions = (permissions || MerbAuthSliceFullfat[:default_permissions])
      self.user_id = with_user.id
      generate_token_key!
      return save
    else
      return false
    end
  end
  
  # Checks to see if this Authentication is activated - if there is an access key defined, then
  # true is returned.
  #def activated?
  #  ac
  #end
  
  # Assigns a valid, unique request_key to the object if one is not already defined.  
  def create_token_key_if_not_present
    generate_token_key! if token_key.blank?
  end
  
  def create_secret_if_not_present
    self.secret ||= MerbAuthSliceFullfat::KeyGenerators::Alphanum.gen(30)
  end
    
  # Generates a valid, unique access_key which the client can use to authenticate with in future,
  # and applies it to the object.
  def generate_token_key!
    while (token_key.blank? or self.class.first(:token_key=>token_key)) do
      self.token_key = MerbAuthSliceFullfat::KeyGenerators::Alphanum.gen(30)
    end
  end
  
  # Returns true if the given user is the owner of this object.
  def editable_by_user?(user)
    return user.id == user_id
  end
  
  # Returns the permissions for this particular token, or the :default_permissions if not set.
  def permissions
    attribute_get(:permissions) or MerbAuthSliceFullfat[:default_permissions]
  end
  
  # Returns true if the set permissions are a valid value according to the keys of the slice's :client_permission_levels hash.
  def permissions_valid?
    MerbAuthSliceFullfat[:client_permission_levels].keys.include?(permissions.to_sym)
  end
  
  # Transformation - returns a hash representing this object, ready to be converted to XML, JSON or YAML.
  def to_hash
    if activated?
      {
        :access_key=>{
          :token=>token_key,
          :secret=>secret,
          :expires=>expires
        }
      }
    else
      {
        :request_key=>{
          :token=>token_key,
          :secret=>secret,
          :expires=>expires
        }
      }      
    end
  end
  # FIXME why is to_xml not available?
  def to_xml;   (activated?)? "<access-key><token>#{token_key}</token><secret>#{secret}</secret><expires>#{expires}</expires></access-key>" : "<request-key><token>#{token_key}</token><secret>#{secret}</secret><expires>#{expires}</expires></request-key>"; end
  def to_json;  to_hash.to_json; end
  def to_yaml;  to_hash.to_yaml; end
  
  
end