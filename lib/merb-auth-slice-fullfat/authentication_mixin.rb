module Merb
  class Authentication
   
   def store_user(user)
     user
   end
   
   def fetch_user(session_contents = session[:user])
     session_contents
   end
    
  end
end