module MerbAuthSliceFullfat
  module ControllerMixin
        
    def ensure_signed
      raise Merb::Controller::NotAcceptable unless request.signed?
    end
        
  end
end