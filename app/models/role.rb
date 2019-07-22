class Role < ActiveRecord::Base
  not_multitenant

  has_many :users
end
