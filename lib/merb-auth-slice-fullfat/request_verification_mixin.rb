=begin
MerbAuthSliceFullfat::Request::VerificationMixin is a mixin module for Merb's internal Request class.

It provides
=end

require 'digest/sha1'

module MerbAuthSliceFullfat
  module Request
    module VerificationMixin
      
      # Returns TRUE if the request contains api-flavour parameters. At least an api_token and an api_signature must be present
      def api_request?
        return true if api_key and api_signature
        return false
      end
      
      # Returns the client referenced by the API token in the given request, or nil if
      # no api key was given or if the given api key was invalid.
      def authenticating_client
        #return false unless signed?
        @authenticating_client ||= MerbAuthSliceFullfat::AuthenticatingClient.first(:api_key=>api_key)
      end
      
      # Attempts to verify the request's signature using the strategy covered in signing.markdown.
      # Takes one argument, which is the authenticating client you wish to check the signature against.
      # Returns a true on success, false on fail.
      def signed?
        # Fail immediately if the request is not signed at all
        return false unless api_request? and authenticating_client
        # Prepare the verification string for comparison
        correct_sig = "#{authenticating_client.secret}#{method}#{protocol}#{host}#{uri}"
        # pop signature off the parameter list and serialize params
        p = signature_params
        correct_sig += "#{p.keys.sort}#{p.values.sort}"
        # mash and compare with given signature
        #raise RuntimeError, "wanted #{correct_sig.inspect} but was signed with #{api_signature.inspect}"
        match = Digest::SHA1.hexdigest(correct_sig) == api_signature
        #match or raise(RuntimeError, "failed to match signature, expected #{correct_sig.inspect} for parameters #{p.inspect} and uri #{full_uri.inspect}")
      end
      
      # Scrubs route parameters from the known params, returning a hash of known GET and POST parameters.
      # Basically, this returns the parameters needed in the signature key/value gibberish.
      def signature_params
        p = params.dup
        route, route_params = Merb::Router.route_for(self)
        #raise RuntimeError, route_params.inspect
        return p.delete_if {|k,v| route_params.keys.map{|s|s.to_s}.include?(k.to_s) or k.to_s == MerbAuthSliceFullfat[:api_signature_param].to_s}
      end
      
      # Returns the value of the api_key parameter from the request parameters.
      # The key used for this is defined by MerbAuthSliceFullfat's :api_key_param option.
      def api_key
        params[MerbAuthSliceFullfat[:api_key_param]]
      end
      
      # Returns the value of the api_token parameter from the request parameters.
      # The key used for this is defined by MerbAuthSliceFullfat's :api_token_param option.
      def api_token
        params[MerbAuthSliceFullfat[:api_token_param]]
      end
      
      # Returns the value of the api_signature parameter from the request parameters.
      # The key used for this is defined by MerbAuthSliceFullfat's :api_signature_param option.
      def api_signature
        params[MerbAuthSliceFullfat[:api_signature_param]]
      end
      
      # Returns the value of the api_receipt parameter from the request parameters.
      # The key used for this is defined by MerbAuthSliceFullfat's :api_receipt_param option.
      def api_receipt
        params[MerbAuthSliceFullfat[:api_receipt_param]]
      end
      
    end
  end
end