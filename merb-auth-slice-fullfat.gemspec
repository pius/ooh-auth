Gem::Specification.new do |s|
  s.name = %q{ooh-auth}
  s.version = "0.9.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Glegg"]
  s.date = %q{2008-10-22}
  s.description = %q{Merb Slice that provides RESTful authentication functionality for your application.}
  s.email = %q{dan@angryameoba.co.uk}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/ooh-auth", "lib/ooh-auth/merbtasks.rb", "lib/ooh-auth/slicetasks.rb", "lib/ooh-auth/spectasks.rb", "lib/ooh-auth.rb", "spec/controllers", "spec/controllers/main_spec.rb", "spec/controllers/sessions_spec.rb", "spec/ooh-auth_spec.rb", "spec/models", "spec/models/password_reset_spec.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/main.rb", "app/controllers/sessions.rb", "app/helpers", "app/helpers/application_helper.rb", "app/helpers/sessions_helper.rb", "app/models", "app/models/password_reset.rb", "app/views", "app/views/layout", "app/views/layout/ooh_auth.html.erb", "app/views/main", "app/views/main/index.html.erb", "app/views/sessions", "app/views/sessions/index.html.erb", "public/javascripts", "public/javascripts/master.js", "public/stylesheets", "public/stylesheets/master.css", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/application.rb", "stubs/app/controllers/main.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/danski/ooh-auth}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Merb Slice that provides RESTful authentication functionality for your application.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<merb-slices>, [">= 0.9.10"])
    else
      s.add_dependency(%q<merb-slices>, [">= 0.9.10"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 0.9.10"])
  end
end
