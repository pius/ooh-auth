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

  provides :xml, :yaml, :json
  before :ensure_authenticated, :exclude=>[:index]
  
  def index
    if request.api_key and request.api_receipt
      # Signed request with a receipt - let's dish up an auth token
      raise NotFound unless @authentication = ::Authentication.get_receipt(request.api_receipt)
      @authentication.activate!
      display @authentication
    elsif client = request.authenticating_client
      # Signed request with no receipt - let's dish up a receipt
      @authentication = ::Authentication.create_receipt(client) 
      display @authentication
    else
      # Some kind of downright nasty fraudlent, mangled request.
      # Probably sent by a circus clown who drinks too much.
      raise NotAcceptable
    end
  end

  def show(id)
    @authentication = ::Authentication.get(id)
    raise NotFound unless @authentication
    display @authentication
  end

  def new
    only_provides :html
    @authentication = MerbAuthSliceFullfat::Authentication.new
    display @authentication
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
