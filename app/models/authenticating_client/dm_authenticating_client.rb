=begin
MerbAuthSliceFullfat::AuthenticatingClient
========================================================================================
An authenticating client is an external application which wants to use your application's public API while authenticated as one of your users.
=end

class MerbAuthSliceFullfat::AuthenticatingClient
  include DataMapper::Resource
  
  property :id,       Serial
  property :user_id,  Integer


end