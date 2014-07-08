class User < ActiveRecord::Base
  include NameHolder
  include EmailHolder
  include PasswordHolder
end
