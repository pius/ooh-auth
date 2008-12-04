=begin
MerbAuthSliceFullfat::Request::VerificationMixin is a mixin module for Merb's internal Request class.

It provides
=end

require 'digest'
require 'openssl'


module MerbAuthSliceFullfat
  module Request
    module VerificationMixin
      
      include OpenSSL
      include Digest
            
      # Returns TRUE if the request contains api-flavour parameters. At least an api_token and an api_signature must be present
      def oauth_request?
        (consumer_key)? true : false
      end
      
      # Returns the authenticating client referenced by the consumer key in the given request, or nil if
      # no consumer key was given or if the given consumer key was invalid.
      def authenticating_client
        #return false unless signed?
        @authenticating_client ||= MerbAuthSliceFullfat::AuthenticatingClient.first(:api_key=>consumer_key)
      end
      
      # Attempts to verify the request's signature using the strategy covered in signing.markdown.
      # Takes one argument, which is the authenticating client you wish to check the signature against.
      # Returns a true on success, false on fail.
      def signed?
        # Fail immediately if the request is not signed at all
        return false unless oauth_request? and authenticating_client
        
        given_sig = self.signature
        wanted_sig = signature_base_string
        # mash and compare with given signature
        case signature_method
        when "HMAC-SHA1"
          crypt = HMAC.new(authenticating_client.secret, SHA1.new)
          crypt.update wanted_sig
          given_sig == crypt.to_s
          
        end
      end
      
      # Creates a plaintext version of the signature base string ready to be run through any#
      # of the support OAuth signature methods.
      # See http://oauth.net/core/1.0#signing_process for more information.
      def signature_base_string
        "#{method.to_s.upcase}&#{full_uri}&#{normalise_signature_params}"
      end
      
      # Returns the params properly merged with the oauth headers if they were given.
      # OAuth headers take priority if a GET/POST parameter with the same name exists.
      def oauth_merged_params
        params.merge(signature_oauth_headers)
      end
      
      # Scrubs route parameters from the known params, returning a hash of known GET and POST parameters.
      # Basically, this returns the parameters needed in the signature key/value gibberish.
      # FIXME unidentified request gremlins seeding params with mix of symbol and string keys, requiring to_s filth all over the match block.
      def signature_params
        route, route_params = Merb::Router.route_for(self)
        #raise RuntimeError, route_params.inspect
        return oauth_merged_params.delete_if {|k,v| route_params.keys.map{|s|s.to_s}.include?(k.to_s) or k.to_s == "oauth_signature"}
      end
      
          # Returns the signature_params as a normalised string in line with
          # http://oauth.net/core/1.0#signing_process
          def normalise_signature_params
            signature_params.sort.collect{|key, value| "#{key}=#{value}"}.join("&")
          end
      
      # Returns any given OAuth headers as specified in http://oauth.net/core/1.0#auth_header as a hash.
      def oauth_headers
        @oauth_headers ||= parse_oauth_headers
      end

          # Returns the auth headers for duplicating the request signature,
          # missing the realm variable as defined in
          # http://oauth.net/core/1.0#signing_process
          def signature_oauth_headers
            o = oauth_headers.dup; o.delete(:realm); o
          end
            
          # Parses the given OAuth headers into a hash. See http://oauth.net/core/1.0#auth_header for parsing method.
          def parse_oauth_headers
            # Pull headers and return blank hash if no header variables found
            headers = env['AUTHORIZATION']; result = {};
            return result unless headers  && headers[0,5] == 'OAuth'
            # Headers found. Go ahead and match 'em
            headers.split(/,\n*\r*/).each do |param|
              phrase, key, value = param.match(/([A-Za-z0-9_\s]+)="([^"]+)"/).to_a.map{|v| v.strip}
              result[(key["OAuth"])? :realm : key.to_sym] = value
            end
            result
          end
      


      # OAuth variable accessors
      # --------------------------------------------------------------------------------------------
      # oauth_consumer_key="0685bd9184jfhq22",
      # oauth_token="ad180jjd733klru7",
      # oauth_signature_method="HMAC-SHA1",
      # oauth_signature="wOJIO9A2W5mFwDgiDvZbTSMK%2FPY%3D",
      # oauth_timestamp="137131200",
      # oauth_nonce="4572616e48616d6d65724c61686176",
      # oauth_version="1.0"

      # Returns the requested signature signing mechanism from the auth headers, defaulting to HMAC-SHA1
      def signature_method
        params[:oauth_signature_method] || "HMAC-SHA1"
      end
      
      # Returns the oauth_consumer_key from the Authorization header or the GET/POST params, or nil if not present.
      def consumer_key
        oauth_merged_params[:oauth_consumer_key]
      end
      
      # Returns the oauth_token from the Authorization header or the GET/POST params, or nil if not present.
      def token
        oauth_merged_params[:oauth_token]
      end
      
      # Returns the oauth_signature from the Authorization header or the GET/POST params, or nil if not present.
      def signature
        oauth_merged_params[:oauth_signature]
      end
      
      # Returns the oauth_timestamp from the Authorization header or the GET/POST params, or nil if not present.
      def timestamp
        oauth_merged_params[:oauth_timestamp]
      end
      
      # Returns the oauth_nonce from the Authorization header or the GET/POST params, or nil if not present.
      def nonce
        oauth_merged_params[:oauth_nonce]
      end
      
      # Returns the oauth_version from the Authorization header or the GET/POST params, or nil if not present, defaulting to "1.0" if not given.
      def oauth_version
        oauth_merged_params[:oauth_version] || "1.0"
      end
      
    end
  end
end