module MerbAuthSliceFullfat
   module Mocks
       class User
           
            GOOD_ID = 1337
            GOOD_LOGIN = "Dr. Kintobor".freeze
            GOOD_PASSWORD = "betteronthegenesis".freeze

            def self.authenticate(login, pass)
              o = new
              o.id = GOOD_ID
              return o if login == GOOD_LOGIN and pass == GOOD_PASSWORD
              return nil
            end
            
            attr_accessor :id            
            attr_accessor :password
            
            def save
              true
            end
                                 
       end
   end 
end