class MerbAuthSliceFullfat::AuthenticatingClients < MerbAuthSliceFullfat::Application
  
  before :ensure_authenticated, :exclude=>[:index]
  only_provides :html

  def index
    @authenticating_clients = MerbAuthSliceFullfat::AuthenticatingClient.find_for_user(session.user)
    render :index
  end

  def show(id)
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client and session.user.id == @authenticating_client.user_id
    display @authenticating_client
  end

  def new
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.new
    display @authenticating_client
  end

  def create(authenticating_client)
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.new(authenticating_client)
    @authenticating_client.user_id = session.user.id
    if @authenticating_client.save
      headers['Location'] = slice_url(:authenticating_client, @authenticating_client)
      render :show, :status=>201
    else
      message[:error] = "There were problems creating the Application."
      render :new
    end
  end

  def edit(id)
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client and session.user.id == @authenticating_client.user_id
    display @authenticating_client, :edit
  end

  def update(id, authenticating_client)
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client and session.user.id == @authenticating_client.user_id
    if @authenticating_client.update_attributes(authenticating_client)
      message[:success] = "Application updated successfully!"
      redirect slice_url(:authenticating_client, @authenticating_client)
    else
      display @authenticating_client, :edit
    end
  end

  def destroy(id)
    @authenticating_client = MerbAuthSliceFullfat::AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client and session.user.id == @authenticating_client.user_id
    if @authenticating_client.destroy
      redirect slice_url(:authenticating_clients)
    else
      raise InternalServerError
    end
  end

end # MerbAuthSliceFullfat::AuthenticatingClients
