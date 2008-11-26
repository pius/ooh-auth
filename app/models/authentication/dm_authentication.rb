=begin
 Authentication model
 
 An Authentication is a single example of permissions given by a user to an authenticating application
 to act on his or her behalf. Each Authentication must relate to a user, and an authenticating application.
 There will be only one Authentication per application per user.
 
 During the authorisation process an object called a 'receipt' is created - the receipt is a key which can
 be used to retrieve a proper Authentication token.
=end

class MerbAuthSliceFullfat::Authentication
  include DataMapper::Resource
  
  property :id, Serial
end