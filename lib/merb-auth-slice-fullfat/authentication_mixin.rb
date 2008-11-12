module Merb
  class Authentication
   
   def store_user(user)
     user.id
   end
   
   def fetch_user(session_contents = session[:user])
     Merb::Authentication.user_class.get(session_contents)
   end
    
  end
end