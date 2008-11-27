MerbAuthSliceFullfat::Mocks::User.fixture{{
  :name         => (name = /\w+/.gen),
  :login        => name,
  :email        => "#{name}@test.com",
  :password     => (password = "#{name}_goodpass"),
  :password_confirmation => password
}}

MerbAuthSliceFullfat::PasswordReset.fixture{{
  :secret       =>  /\w+/.gen,
  :identifier   =>  /\w+/.gen,
  :user_id      =>  /\d{1,3}/.gen,
  :created_at   =>  Time.now - (60*60*24)
}}

MerbAuthSliceFullfat::AuthenticatingClient.fixture{{
  :user_id      =>  /\d{1,3}/.gen,
  :name         =>  /\w+/.gen,
  :web_url      =>  "http://www.#{ /\w+/.gen }.com/client/",
  :icon_url     =>  "http://www.#{ /\w+/.gen }.com/client.jpg",
  :api_key      =>  /\w+/.gen,
  :secret       =>  /\w+/.gen,
  :callback_url =>  "http://www.#{ /\w+/.gen }.com/auth_completed",
  :kind         =>  /desktop|web/.gen
}}

MerbAuthSliceFullfat::Authentication.fixture{{
  
}}