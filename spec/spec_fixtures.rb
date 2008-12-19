OohAuth::Mocks::User.fixture{{
  :name         => (name = /\w+/.gen),
  :login        => name,
  :email        => "#{name}@test.com",
  :password     => (password = "#{name}_goodpass"),
  :password_confirmation => password
}}

OohAuth::AuthenticatingClient.fixture{{
  :name         =>  /\w+/.gen,
  :web_url      =>  "http://www.#{ /\w+/.gen }.com/client/",
  :api_key      =>  /\w+/.gen,
  :secret       =>  /\w+/.gen,
  :kind         =>  /desktop|web/.gen
}}

OohAuth::Token.fixture{{
  
}}