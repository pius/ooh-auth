class MerbAuthSliceFullfat::Authentications < MerbAuthSliceFullfat::Application
  # provides :xml, :yaml, :js

  def index
    @authentications = MerbAuthSliceFullfat::Authentication.all
    display @authentications
  end

  def show(id)
    @authentication = MerbAuthSliceFullfat::Authentication.get(id)
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
