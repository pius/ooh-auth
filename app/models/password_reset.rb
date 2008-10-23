path = File.expand_path(File.dirname(__FILE__)) / "password_reset"
if defined?(DataMapper)
  require path / "dm_password_reset"
#elsif defined?(ActiveRecord)
#  require path / "ar_password_reset"
#elsif defined?(Sequel)
#  require path / "sq_password_reset"
#elsif defined?(RelaxDB)
#  require path / "relaxdb_password_reset"
else
  raise RuntimeError, "Datamapper is a dependency of the slice at this time."
end
