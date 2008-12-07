
Usage
------------------------------------------------------------------------------
To see all available tasks for OohAuth run:

rake -T slices:ooh_auth

Installation
------------------------------------------------------------------------------

Instructions for installation:

file: config/init.rb

# add the slice as a regular dependency

dependency 'ooh-auth'

# if needed, configure which slices to load and in which order

Merb::Plugins.config[:merb_slices] = { :queue => ["OohAuth", ...] }

# optionally configure the plugins in a before_app_loads callback

Merb::BootLoader.before_app_loads do
  
  Merb::Slices::config[:ooh_auth][:option] = value
  
end

file: config/router.rb

# example: /ooh_auth/:controller/:action/:id

add_slice(:OohAuth)

# example: /foo/:controller/:action/:id

add_slice(:OohAuth, 'foo') # same as :path => 'foo'

# example: /:lang/:controller/:action/:id

add_slice(:OohAuth, :path => ':lang')

# example: /:controller/:action/:id

slice(:OohAuth)

Normally you should also run the following rake task:

rake slices:ooh_auth:install

You can put your application-level overrides in:

host-app/slices/ooh-auth/app - controllers, models, views ...

Templates are located in this order:

1. host-app/slices/ooh-auth/app/views/*
2. gems/ooh-auth/app/views/*
3. host-app/app/views/*

You can use the host application's layout by configuring the
ooh-auth slice in a before_app_loads block:

Merb::Slices.config[:ooh_auth] = { :layout => :application }

By default :ooh_auth is used. If you need to override
stylesheets or javascripts, just specify your own files in your layout
instead/in addition to the ones supplied (if any) in 
host-app/public/slices/ooh-auth.

In any case don't edit those files directly as they may be clobbered any time
rake ooh_auth:install is run.

