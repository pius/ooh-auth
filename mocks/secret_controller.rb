class MerbAuthSliceFullfat::Secrets < MerbAuthSliceFullfat::Application
  
  before :ensure_authenticated
  
  def index
    provides :xml, :json, :yml
    case content_type
    when :html
      "HOLY SHIT YOU FOUND MAH SEKKRIT USIN UR SESHUNS"
    else
      "OMFG U HTTP AUTHUROSED LULZ"
    end
  end
  
end