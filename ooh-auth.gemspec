# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ooh-auth}
  s.version = "0.1.10"

  s.authors = ["Dan Glegg"]
  s.date = %q{2008-10-22}
  s.description = %q{Merb slice that adds OAuth provider capabilities to any merb-auth application.}
  s.summary = %q{Merb Slice that provides RESTful authentication functionality for your application.}
  s.email = %q{dan@angryameoba.co.uk}

  s.extra_rdoc_files = ["readme.markdown", "LICENSE"]
  s.files = ["LICENSE", "readme.markdown", "Rakefile", "lib/ooh-auth", "lib/ooh-auth/authentication_mixin.rb", "lib/ooh-auth/controller_mixin.rb", "lib/ooh-auth/key_generators.rb", "lib/ooh-auth/merbtasks.rb", "lib/ooh-auth/request_verification_mixin.rb", "lib/ooh-auth/slicetasks.rb", "lib/ooh-auth/spectasks.rb", "lib/ooh-auth/strategies", "lib/ooh-auth/strategies/oauth.rb", "lib/ooh-auth.rb", "spec/controllers", "spec/controllers/application_spec.rb", "spec/controllers/authenticating_clients_spec.rb", "spec/controllers/tokens_spec.rb", "spec/merb-auth-slice-fullfat_spec.rb", "spec/models", "spec/models/authenticating_client_spec.rb", "spec/models/oauth_strategy_spec.rb", "spec/models/request_verification_mixin_spec.rb", "spec/models/token_spec.rb", "spec/spec_fixtures.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/authenticating_clients.rb", "app/controllers/tokens.rb", "app/helpers", "app/helpers/application_helper.rb", "app/helpers/authenticating_clients_helper.rb", "app/helpers/authentications_helper.rb", "app/models", "app/models/authenticating_client", "app/models/authenticating_client/dm_authenticating_client.rb", "app/models/authenticating_client.rb", "app/models/token", "app/models/token/dm_token.rb", "app/models/token.rb", "app/views", "app/views/authenticating_clients", "app/views/authenticating_clients/_help.html.erb", "app/views/authenticating_clients/edit.html.erb", "app/views/authenticating_clients/index.html.erb", "app/views/authenticating_clients/new.html.erb", "app/views/authenticating_clients/show.html.erb", "app/views/layout", "app/views/layout/ooh_auth.html.erb", "app/views/tokens", "app/views/tokens/create.html.erb", "app/views/tokens/edit.html.erb", "app/views/tokens/new.html.erb", "app/views/tokens/show.html.erb", "public/javascripts", "public/javascripts/master.js", "public/stylesheets", "public/stylesheets/master.css", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/application.rb", "stubs/app/controllers/main.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/danski/ooh-auth}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}

  s.add_dependency(%q<ruby-hmac>, [">= 0.3.2"])

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, [">= 0.9.10"])
    else
      s.add_dependency(%q<merb-slices>, [">= 0.9.10"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 0.9.10"])
  end
end
