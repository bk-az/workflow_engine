class Role < ActiveRecord::Base
  has_many :users

  def self.admin
    find_by(name: 'Administrator')
  end
end
