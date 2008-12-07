=begin
OohAuth::Tokens

This controller is intended to allow applications to authenticate on behalf of a user. 
Applications follow a set process as shown in authenticating.markdown, in which a number of background 
requests are made to the host application while the user is run through a short process in which they
specify which privileges to give to the authenticating client, and how long to give them for.

The Authentications controller provides a relatively opaque interface to 
users and authenticating clients compared to other resource controllers. Most of the views provide only HTML
representations as they not only are intended for human interaction, but specifically require it.
=end

require 'net/http'

class OohAuth::Tokens < OohAuth::Application

  # Define other formats
  provides :js, :xml, :yaml

  # The index and new actions require a signed request.
  before :ensure_signed,                    :only=>[:index]
  # All other actions require that the user be authenticated directly, rather than through the api.
  before :forbid_authentication_with_oauth, :exclude=>[:index]
  
  # Main action used for starting the authorisation process (desktop clients) and finishing it (web clients)
  def index
    raise NotAcceptable unless @authenticating_client = request.authenticating_client
    if @token = request.authentication_token
      # If client and request key, give the activated token if it was activated.
      raise NotAcceptable unless @token.authenticating_client == @authenticating_client
    else
      # Generate a request key
      @token = OohAuth::Token.create_request_key(@authenticating_client)
    end
    # # Okay, no error raised. Gogo render.
    display @token, :show, :layout=>nil
  end

  def new
    only_provides :html
    unless (@token = OohAuth::Token.first(:token_key=>request.token) and
            @authenticating_client = @token.authenticating_client)
      raise NotAcceptable 
    end
    display @token, :new
  end

  # Activates an authentication receipt, converting it into a token the authenticating client can use in future requests.
  def create(token)
    only_provides :html
    commit = (params[:commit]=="allow") # Did they click the allow or the deny button? ENQUIRING MINDS NEED TO KNOW!
    raise NotFound unless @token = OohAuth::Token.get_token(request.token) # The oauth_token is now in the post body.
    raise NotFound unless @authenticating_client = @token.authenticating_client # Stop right there, criminal scum.
        
    @activated = @token.activate!(session.user, token[:expires], token[:permissions]) if commit
    redirect("#{request.callback}#{(request.callback["?"])? "&" : "?"}oauth_token=#{@token.token_key}") if commit and request.callback # the callback is in the post body        
    display @token, :create
  end
  
  #def show(id)
  #  @token = ::Authentication.get(id)
  #  raise NotFound unless @token
  #  display @token
  #end
  #
  #def edit(id)
  #  only_provides :html
  #  @token = OohAuth::Token.get(id)
  #  raise NotFound unless @token
  #  display @token
  #end
  #
  #def update(id, token)
  #  @token = OohAuth::Token.get(id)
  #  raise NotFound unless @token
  #  if @token.update_attributes(authentication)
  #     redirect slice_url(:tokens, @token)
  #  else
  #    display @token, :edit
  #  end
  #end
  #
  #def destroy(id)
  #  @token = OohAuth::Token.get(id)
  #  raise NotFound unless @token
  #  if @token.destroy
  #    redirect slice_url(:tokens)
  #  else
  #    raise InternalServerError
  #  end
  #end

end # OohAuth::Tokens
