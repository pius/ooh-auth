# Authentication Strategy for MerbAuthSliceFullfat's AuthenticatingClient model.

class Merb::Authentication
  module Strategies
    module Basic
      class APIToken < Merb::Authentication::Strategy
        
        def run!
          if request.signed? and token_param and api_key_param
            return MerbAuthSliceFullfat::Authentication.authenticate!(api_key_param, token_param)
          end
          return nil
        end
        
        private
        def token_param
          request.params[MerbAuthSliceFullfat[:api_token_param]]
        end
        def api_key_param
          request.params[MerbAuthSliceFullfat[:api_key_param]]
        end
        
      end # APIToken      
    end # Basic
  end # Strategies
end # MAuth