MerbAuthSliceFullfat::PasswordReset.fixture{{
  :passphrase   =>  /\w+/.gen,
  :key          =>  /\w+/.gen,
  :user_id      =>  /\d{1, 3}/.gen,
  :created_at   =>  Time.now - (60*60*24)
}}