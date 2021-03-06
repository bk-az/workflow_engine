class Role < ActiveRecord::Base
  not_multitenant

  has_many :users

  ROLES = {
    administrator: 'Administrator',
    member: 'Member'
  }

  def self.admin
    find_by(name: ROLES[:administrator])
  end

  def self.member
    find_by(name: ROLES[:member])
  end
end
