# Authentication Strategy for MerbAuthSliceFullfat's AuthenticatingClient model.

class Merb::Authentication
  module Strategies
    module Basic
      class APIToken < Merb::Authentication::Strategy
        
        def run!
          if request.signed? and token_param and api_key_param
            return MerbAuthSliceFullfat::Token.authenticate!(request.consumer_key, request.token)
          end
          return nil
        end
              
      end # APIToken      
    end # Basic
  end # Strategies
end # MAuth