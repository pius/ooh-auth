MerbAuthSliceFullfat::Mocks::User.fixture{{
  :name         => (name = /\w+/.gen),
  :login        => name,
  :email        => "#{name}@test.com",
  :password     => (password = "#{name}_goodpass"),
  :password_confirmation => password
}}

MerbAuthSliceFullfat::AuthenticatingClient.fixture{{
  :user_id      =>  /\d{1,3}/.gen,
  :name         =>  /\w+/.gen,
  :web_url      =>  "http://www.#{ /\w+/.gen }.com/client/",
  :api_key      =>  /\w+/.gen,
  :secret       =>  /\w+/.gen,
  :kind         =>  /desktop|web/.gen
}}

MerbAuthSliceFullfat::Token.fixture{{
  
}}