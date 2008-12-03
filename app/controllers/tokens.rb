=begin
MerbAuthSliceFullfat::Tokens

This controller is intended to allow applications to authenticate on behalf of a user. 
Applications follow a set process as shown in authenticating.markdown, in which a number of background 
requests are made to the host application while the user is run through a short process in which they
specify which privileges to give to the authenticating client, and how long to give them for.

The Authentications controller provides a relatively opaque interface to 
users and authenticating clients compared to other resource controllers. Most of the views provide only HTML
representations as they not only are intended for human interaction, but specifically require it.
=end

require 'net/http'

class MerbAuthSliceFullfat::Tokens < MerbAuthSliceFullfat::Application

  # The index and new actions require a signed request.
  before :ensure_signed,        :only=>[:index, :new]
  # All other actions require that the user be authenticated directly, rather than through the api.
  before :ensure_authenticated_personally, :exclude=>[:index]  
  
  # Main action used for starting the authorisation process (desktop clients) and finishing it (web clients)
  def index
    only_provides :js, :xml, :yaml
    if request.api_key and request.api_receipt
      # Signed request with a receipt - let's dish up an auth token
      # This is the end point for web-based authorisation
      raise NotFound unless @token = MerbAuthSliceFullfat::Token.get_receipt_for_client(request.authenticating_client, request.api_receipt)
      @token.activate!
    elsif client = request.authenticating_client
      # Signed request with no receipt - let's dish up a receipt
      # This is the start point for desktop authorisation.
      @token = MerbAuthSliceFullfat::Token.create_receipt(client) 
    end
    # Some kind of downright nasty fraudlent, mangled request.
    # Probably sent by a circus clown who drinks too much.
    raise NotAcceptable unless @token
    # Okay, no error raised. Gogo render.
    display @token, :index
  end

  def new
    only_provides :html
    raise NotFound unless @authenticating_client = request.authenticating_client
    # Get receipt if given for a desktop client (web clients create the receipt at a different moment in the process)
    unless @authenticating_client.is_webapp?
      raise NotAcceptable unless @token = MerbAuthSliceFullfat::Token.get_receipt_for_client(@authenticating_client, request.api_receipt)
    end
    display @token, :new
  end

  # Activates an authentication receipt, converting it into a token the authenticating client can use in future requests.
  def create
    only_provides :html
    raise NotFound unless @authenticating_client = request.authenticating_client
    if @authenticating_client.is_webapp?
      # If the client is a web app, then no receipt currently exists. We'll create one and activate it in place.
      @token = @token = MerbAuthSliceFullfat::Token.create_receipt(@authenticating_client, 1.hour.since, session.user)
      # Trigger the callback URL
      callback_uri = URI.parse("#{@authenticating_client.callback_url}?api_receipt=#{@token.receipt}")
      Net::HTTP.get_response(callback_uri) rescue @callback_failed = true
      # Fall over to render
    else
      # If the client is a desktop or mobile app, then we need to locate the current receipt from the params and activate it.
      @token = MerbAuthSliceFullfat::Token.get_receipt_for_client(@authenticating_client, request.api_receipt)
      @token.user = session.user
      # Fall over to the render
    end
    @token.activate!(1.year.since, request.api_permissions)
    display @token, :show
  end
  
  def show(id)
    @token = ::Authentication.get(id)
    raise NotFound unless @token
    display @token
  end

  def edit(id)
    only_provides :html
    @token = MerbAuthSliceFullfat::Token.get(id)
    raise NotFound unless @token
    display @token
  end
  
  def update(id, token)
    @token = MerbAuthSliceFullfat::Token.get(id)
    raise NotFound unless @token
    if @token.update_attributes(authentication)
       redirect slice_url(:tokens, @token)
    else
      display @token, :edit
    end
  end

  def destroy(id)
    @token = MerbAuthSliceFullfat::Token.get(id)
    raise NotFound unless @token
    if @token.destroy
      redirect slice_url(:tokens)
    else
      raise InternalServerError
    end
  end

end # MerbAuthSliceFullfat::Tokens
