=begin
MerbAuthSliceFullfat::Request::VerificationMixin is a mixin module for Merb's internal Request class.

It provides
=end

require 'digest/sha1'

module MerbAuthSliceFullfat
  module Request
    module VerificationMixin
      
      # Attempts to verify the request's signature using the strategy covered in signing.markdown.
      # Takes one argument, which is the authenticating client you wish to check the signature against.
      # Returns a true on success, false on fail.
      def signed_by?(authenticating_client)
        # Fail immediately if the request is not signed at all
        return false unless api_signature and api_key
        # Prepare the verification string for comparison
        # pop signature off the parameter list
        # serialize params
        # mash with given client
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