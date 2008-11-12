MerbAuthSliceFullfat::Mocks::User.fixture{{
  :name         => (name = /\w+/.gen),
  :login        => name,
  :email        => "#{name}@test.com",
  :password     => (password = "#{name}_goodpass"),
  :password_confirmation => password
}}

MerbAuthSliceFullfat::PasswordReset.fixture{{
  :passphrase   =>  /\w+/.gen,
  :key          =>  /\w+/.gen,
  :user_id      =>  /\d{1, 3}/.gen,
  :created_at   =>  Time.now - (60*60*24)
}}