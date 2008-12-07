# Authentication Strategy for OohAuth's AuthenticatingClient model.

class Merb::Authentication
  module Strategies
    class OAuth < Merb::Authentication::Strategy
        
        def run!
          if request.signed? and request.token and request.consumer_key
            return OohAuth::Token.authenticate!(request.consumer_key, request.token)
          end
          return nil
        end
              
      end # APIToken      
  end # Strategies
end # MAuth