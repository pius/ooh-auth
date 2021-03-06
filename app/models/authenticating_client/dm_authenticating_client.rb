=begin
OohAuth::AuthenticatingClient
========================================================================================
An authenticating client is an external application which wants to use your application's public API while authenticated as one of your users.
=end

class OohAuth::AuthenticatingClient
  include DataMapper::Resource
  
  # Key it
  property :id,             Serial
  # The registration will belong to a user, who will be able to edit the client properties.
  property :user_id,        Integer,  :writer => :protected
  # Timestamp it
  property :created_at,     DateTime
   
  # Used by all type of authenticating apps                         
  property :name,           String      # e.g. "Mobilator PRO"
  property :web_url,        URI         # e.g. "http://mobilator.portionator.net"
  property :api_key,        String, :index=>true # the unique key for this application.
  property :secret,         String      # the secret which will NEVER be transmitted during the authentication procedure. Used only to sign requests.
  property :kind,           String      # e.g  "desktop", "web", "mobile"

  validates_present     :name, :web_url, :api_key, :secret, :kind
  validates_is_unique   :name
  validates_is_unique   :api_key
  validates_with_method :kind, :valid_kind?
  
  before :valid?, :generate_keys_if_not_present
  
  def self.new_for_user(user, attrs)
    o = new(attrs)
    o.user = user
    return o
  end
  
  def self.find_for_user(user)
    return [] unless user
    return all(:user_id=>user.id)
  end
  
  def is_webapp?
    self.kind == "web"
  end
  
  def generate_keys_if_not_present
    api_key_length = 15
    while self.api_key.blank? or self.class.first(:id.not=>id, :api_key=>self.api_key) do
      self.api_key = OohAuth::KeyGenerators::Alphanum.gen(api_key_length)
      api_key_length += 1
    end
    self.secret = OohAuth::KeyGenerators::Alphanum.gen(40) if secret.blank?
  end
  
  def valid_kind?
    if OohAuth[:client_kinds].include?(self.kind)
      return true
    else
      return false, "illegal kind"
    end
  end
  
  def user=(user)
    self.user_id = user.id
  end
  
  def editable_by?(user)
    user.id == self.user_id
  end
  
end # OohAuth::AuthenticatingClient