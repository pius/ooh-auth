=begin
 Authentication model
 
 An Authentication is a single example of permissions given by a user to an authenticating application
 to act on his or her behalf. Each Authentication must relate to a user, and an authenticating application.
 There will be only one Authentication per application per user.
 
 The authorisation process follows roughly the same pattern for both web and desktop clients:
 1. A *receipt* is created and tied to a user and an authenticating client.
    - For web-based clients, the user is run through the authorisation screen and a receipt is sent to the client on acceptance.
    - For desktop clients, a receipt is requested ahead of time and tied to the authenticating client, and then the user is run
      through the authorisation screen to tie that receipt to a user.
 2. The authenticating client uses the receipt key to request the token used in future requests.
 
 In each case the end result is a receipt created for a client and a user, which may be converted into a token
 with a specially-crafted API request.
=end

class MerbAuthSliceFullfat::Authentication
  include DataMapper::Resource
  
  property  :id,                        Serial
  property  :user_id,                   Integer,  :writer=>:protected
  property  :authenticating_client_id,  Integer,  :writer=>:protected
  
  # Expiry date will always be respected. You cannot authenticate using an expired token, and nor can you
  # convert an expired receipt into a token.
  property  :expires, DateTime
  property  :created_at, DateTime
  
  property  :receipt, String, :writer=>:private, :index=>true
  property  :token,   String, :writer=>:private, :index=>true
  
  validates_is_unique :receipt
  validates_is_unique :token, :if=>:token
  validates_present   :authenticating_client
  
  belongs_to :authenticating_client, :class_name=>"MerbAuthSliceFullfat::AuthenticatingClient", :child_key=>[:authenticating_client_id]
  belongs_to :user, :class_name=>Merb::Authentication.user_class.to_s, :child_key=>[:user_id]
  
  before :valid?, :create_receipt_if_not_present
  
  # Authenticates a client on behalf of a user given the API parameters sent by the client
  # in the given API request. Returns the user on successful authentication, or false in
  # the event of a failure to authenticate. If the user was since deleted, NIL will be
  # returned.
  def self.authenticate!(api_key, api_token)
    auth = first('authenticating_client.api_key'=>api_key, :token=>api_token)
    return (auth)? auth.user : false
  end
  
  # Tentatively create a receipt for a given client, not yet tied to a user.
  def self.create_receipt(authenticating_client, expires=1.hour.since, user=nil)
    o = new(:authenticating_client=>authenticating_client, :expires=>expires, :user=>user)
    o.save; o
  end
  
  # Make this Authentication object active by generating a token against it.
  # You may optionally specify a new expiry date/time for the token.
  def activate!(expire_on=1.year.since)
    if authenticating_client and user
      self.expires = expire_on
      apply_token!
      return save
    else
      return false
    end
  end
  
  # Checks to see if this Authentication is activated - if there is a token defined, then
  # true is returned.
  def activated?
    (token)? true : false
  end
  
  # Assigns a valid, unique receipt to the object if one is not already defined.  
  def create_receipt_if_not_present
    while (new_record? and (receipt.blank? or self.class.first(:receipt=>receipt))) do
      self.receipt = MerbAuthSliceFullfat::KeyGenerators::Alphanum.gen(30)
    end
  end
  
  # Generates a valid, unique token which the client can use to authenticate with in future,
  # and applies it to the object.
  def apply_token!
    while (token.blank? or self.class.first(:token=>token)) do
      self.token = MerbAuthSliceFullfat::KeyGenerators::Alphanum.gen(30)
    end
  end
  
  # Transformations
  def to_hash
    
  end
  
  
end