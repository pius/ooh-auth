class MerbAuthSliceFullfat::AuthenticatingClients < MerbAuthSliceFullfat::Application
  # provides :xml, :yaml, :js

  def index
    @authenticating_clients = AuthenticatingClient.all
    display @authenticating_clients
  end

  def show(id)
    @authenticating_client = AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client
    display @authenticating_client
  end

  def new
    only_provides :html
    @authenticating_client = AuthenticatingClient.new
    display @authenticating_client
  end

  def edit(id)
    only_provides :html
    @authenticating_client = AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client
    display @authenticating_client
  end

  def create(authenticating_client)
    @authenticating_client = AuthenticatingClient.new(authenticating_client)
    if @authenticating_client.save
      redirect resource(@authenticating_client), :message => {:notice => "AuthenticatingClient was successfully created"}
    else
      message[:error] = "AuthenticatingClient failed to be created"
      render :new
    end
  end

  def update(id, authenticating_client)
    @authenticating_client = AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client
    if @authenticating_client.update_attributes(authenticating_client)
       redirect resource(@authenticating_client)
    else
      display @authenticating_client, :edit
    end
  end

  def destroy(id)
    @authenticating_client = AuthenticatingClient.get(id)
    raise NotFound unless @authenticating_client
    if @authenticating_client.destroy
      redirect resource(:authenticating_clients)
    else
      raise InternalServerError
    end
  end

end # AuthenticatingClients
