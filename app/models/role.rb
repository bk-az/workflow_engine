class Role < ActiveRecord::Base
  has_many :users

  ROLES = {
    administrator: 'Administrator',
    member: 'Member'
  }

  def self.admin
    find_by(name: ROLES[:administrator])
  end
end
