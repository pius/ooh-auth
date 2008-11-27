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
  
  property  :id,      Serial
  property  :user_id, Integer, :key=>true
  property  :authenticating_client_id, :key=>true
  
  # Expiry date will always be respected. You cannot authenticate using an expired token, and nor can you
  # convert an expired receipt into a token.
  property  :expires, DateTime
  property  :created_at, DateTime
  
  property  :receipt, String
  property  :token,   String
  
  belongs_to :authenticating_client, :class_name=>"MerbAuthSliceFullfat::AuthenticatingClient", :child_key=>:authenticating_client_id
  belongs_to :user, :class_name=>Merb::Authentication.user_class.to_s
  
  # Authenticates a client on behalf of a user given the API parameters sent by the client
  # in the given API request.
  def self.authenticate!(api_key, api_token)
    
  end
  
  # Tentatively create a receipt for a given client, not yet tied to a user.
  def self.create_for_client(authenticating_client, expiry=1.hour.since)
    
  end
  
  # Make this Authentication object active by generating a token against it.
  # You may optionally specify a new expiry date/time for the token.
  def activate!(expiry=1.year.since)
    
  end
  
end