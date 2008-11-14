=begin
MerbAuthSliceFullfat::AuthenticatingClient
========================================================================================
An authenticating client is an external application which wants to use your application's public API while authenticated as one of your users.
=end

class MerbAuthSliceFullfat::AuthenticatingClient
  include DataMapper::Resource
  
  property :id,             Serial      # Non-controversial so far.
  property :user_id,        Integer     # The registration will belong to a user, who will be able to edit the client properties.
                            
  property :name,           String      # e.g. "Mobilator PRO"
  property :web_url,        String      # e.g. "http://mobilator.portionator.net"
  property :icon_url,       String      # e.g. "http://mobilator.portionator.net.somecdn.com/images/icon_64.png"
  property :api_key,        String      # the unique key for this application.

  validates_is_unique :name, :message=>"That application is already registered."
  validates_is_unique :api_key

end