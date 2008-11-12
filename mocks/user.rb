require 'merb-auth-more/mixins/salted_user'

module MerbAuthSliceFullfat
   module Mocks
       class User
          include DataMapper::Resource
          include Merb::Authentication::Mixins::SaltedUser
           
          property :id,                   Serial
          property :name,                 String
          property :login,                String
          property :email,                String
          property :password,             String

          validates_is_unique         :login, :email
          validates_is_confirmed      :password
       end
   end 
end