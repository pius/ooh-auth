
Usage
------------------------------------------------------------------------------
To see all available tasks for MerbAuthSliceFullfat run:

rake -T slices:merb_auth_slice_fullfat

Installation
------------------------------------------------------------------------------

Instructions for installation:

file: config/init.rb

# add the slice as a regular dependency

dependency 'merb-auth-slice-fullfat'

# if needed, configure which slices to load and in which order

Merb::Plugins.config[:merb_slices] = { :queue => ["MerbAuthSliceFullfat", ...] }

# optionally configure the plugins in a before_app_loads callback

Merb::BootLoader.before_app_loads do
  
  Merb::Slices::config[:merb_auth_slice_fullfat][:option] = value
  
end

file: config/router.rb

# example: /merb_auth_slice_fullfat/:controller/:action/:id

add_slice(:MerbAuthSliceFullfat)

# example: /foo/:controller/:action/:id

add_slice(:MerbAuthSliceFullfat, 'foo') # same as :path => 'foo'

# example: /:lang/:controller/:action/:id

add_slice(:MerbAuthSliceFullfat, :path => ':lang')

# example: /:controller/:action/:id

slice(:MerbAuthSliceFullfat)

Normally you should also run the following rake task:

rake slices:merb_auth_slice_fullfat:install

You can put your application-level overrides in:

host-app/slices/merb-auth-slice-fullfat/app - controllers, models, views ...

Templates are located in this order:

1. host-app/slices/merb-auth-slice-fullfat/app/views/*
2. gems/merb-auth-slice-fullfat/app/views/*
3. host-app/app/views/*

You can use the host application's layout by configuring the
merb-auth-slice-fullfat slice in a before_app_loads block:

Merb::Slices.config[:merb_auth_slice_fullfat] = { :layout => :application }

By default :merb_auth_slice_fullfat is used. If you need to override
stylesheets or javascripts, just specify your own files in your layout
instead/in addition to the ones supplied (if any) in 
host-app/public/slices/merb-auth-slice-fullfat.

In any case don't edit those files directly as they may be clobbered any time
rake merb_auth_slice_fullfat:install is run.

