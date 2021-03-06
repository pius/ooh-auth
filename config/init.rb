#
# ==== Standalone OohAuth configuration
# 
# This configuration/environment file is only loaded by bin/slice, which can be 
# used during development of the slice. It has no effect on this slice being
# loaded in a host application. To run your slice in standalone mode, just
# run 'slice' from its directory. The 'slice' command is very similar to
# the 'merb' command, and takes all the same options, including -i to drop 
# into an irb session for example.
#
# The usual Merb configuration directives and init.rb setup methods apply,
# including use_orm and before_app_loads/after_app_loads.
#
# If you need need different configurations for different environments you can 
# even create the specific environment file in config/environments/ just like
# in a regular Merb application. 
#
# In fact, a slice is no different from a normal # Merb application - it only
# differs by the fact that seamlessly integrates into a so called 'host'
# application, which in turn can override or finetune the slice implementation
# code and views.
#
Merb::Config.use do |c|

  # Sets up a custom session id key which is used for the session persistence
  # cookie name.  If not specified, defaults to '_session_id'.
  # c[:session_id_key] = '_session_id'
  
  # The session_secret_key is only required for the cookie session store.
  c[:session_secret_key]  = '01ca17da4766c4fb709ffefdd6c3268bb5975221'
  
  # There are various options here, by default Merb comes with 'cookie', 
  # 'memory', 'memcache' or 'container'.  
  # You can of course use your favorite ORM instead: 
  # 'datamapper', 'sequel' or 'activerecord'.
  c[:session_store] = 'cookie'
  
  # When running a slice standalone, you're usually developing it,
  # so enable template reloading by default.
  c[:reload_templates] = true
  
end

use_orm :datamapper

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  require OohAuth.root / "mocks" / "user"
  require OohAuth.root / "mocks" / "secret_controller"
  require OohAuth.root / "mocks" / "public_controller"
  Merb::Authentication.user_class = OohAuth::Mocks::User
end

Merb::Router.prepare do
  default_routes
end

dependency "dm-core"        # The datamapper ORM
dependency "dm-aggregates"  # Provides your DM models with count, sum, avg, min, max, etc.
dependency "dm-migrations"  # Make incremental changes to your database.
dependency "dm-timestamps"  # Automatically populate created_at, created_on, etc. when those properties are present.
dependency "dm-types"       # Provides additional types, including csv, json, yaml.
dependency "dm-validations" # Validation framework
dependency "dm-sweatshop"   # Fixture framework