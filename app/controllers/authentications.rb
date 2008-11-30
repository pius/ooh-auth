=begin
MerbAuthSliceFullfat::Authentications

This controller is intended to allow applications to authenticate on behalf of a user. 
Applications follow a set process as shown in authenticating.markdown, in which a number of background 
requests are made to the host application while the user is run through a short process in which they
specify which privileges to give to the authenticating client, and how long to give them for.

The Authentications controller provides a relatively opaque interface to 
users and authenticating clients compared to other resource controllers. Most of the views provide only HTML
representations as they not only are intended for human interaction, but specifically require it.
=end

class MerbAuthSliceFullfat::Authentications < MerbAuthSliceFullfat::Application

  before :ensure_signed,        :only=>[:index, :new]
  before :ensure_authenticated_personally, :exclude=>[:index]  
  
  def index
    only_provides :js, :xml, :yaml
    if request.api_key and request.api_receipt
      # Signed request with a receipt - let's dish up an auth token
      raise NotFound unless @authentication = MerbAuthSliceFullfat::Authentication.get_receipt_for_client(request.authenticating_client, request.api_receipt)
      @authentication.activate!
    elsif client = request.authenticating_client
      # Signed request with no receipt - let's dish up a receipt
      @authentication = MerbAuthSliceFullfat::Authentication.create_receipt(client) 
    end
    # Some kind of downright nasty fraudlent, mangled request.
    # Probably sent by a circus clown who drinks too much.
    raise NotAcceptable unless @authentication
    # Okay, no error raised. Gogo render.
    display @authentication, :index
  end

  #def show(id)
  #  @authentication = ::Authentication.get(id)
  #  raise NotFound unless @authentication
  #  display @authentication
  #end

  def new
    only_provides :html
    raise NotFound unless @authenticating_client = request.authenticating_client
    unless @authenticating_client.is_webapp?
      raise NotAcceptable unless @authentication = MerbAuthSliceFullfat::Authentication.get_receipt_for_client(@authenticating_client, request.api_receipt)
    end    
    display @authentication, :new
  end

  def edit(id)
    only_provides :html
    @authentication = MerbAuthSliceFullfat::Authentication.get(id)
    raise NotFound unless @authentication
    display @authentication
  end

  def create(authentication)
    @authentication = MerbAuthSliceFullfat::Authentication.new(authentication)
    if @authentication.save
      redirect slice_url(:authentications, @authentication), :message => {:notice => "MerbAuthSliceFullfat::Authentication was successfully created"}
    else
      message[:error] = "MerbAuthSliceFullfat::Authentication failed to be created"
      render :new
    end
  end

  def update(id, authentication)
    @authentication = MerbAuthSliceFullfat::Authentication.get(id)
    raise NotFound unless @authentication
    if @authentication.update_attributes(authentication)
       redirect slice_url(:authentications, @authentication)
    else
      display @authentication, :edit
    end
  end

  def destroy(id)
    @authentication = MerbAuthSliceFullfat::Authentication.get(id)
    raise NotFound unless @authentication
    if @authentication.destroy
      redirect slice_url(:authentications)
    else
      raise InternalServerError
    end
  end

end # MerbAuthSliceFullfat::Authentications
