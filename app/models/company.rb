class Company < ActiveRecord::Base
  not_multitenant

  before_save { subdomain.downcase! }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  VALID_SUBDOMAIN_REGEX = /\A([a-z\d]+(-[a-z\d]+)*(_[a-z\d]+)*)\z/i.freeze
  validates :subdomain, presence: true, length: { minimum: 1, maximum: 63 },
                        format: { with: VALID_SUBDOMAIN_REGEX },
                        uniqueness: { case_sensitive: false }
  validates :owner_id, presence: true
  validates :description, length: { minimum: 10, maximum: 200 }

  belongs_to :owner, class_name: 'User' # Owner
  has_many   :users, dependent: :destroy
  has_many   :projects, dependent: :destroy
  has_many   :teams, dependent: :destroy
  has_many   :comments, dependent: :destroy
  has_many   :issues, dependent: :destroy
  has_many   :documents, dependent: :destroy
  has_many   :issue_types, dependent: :destroy
  has_many   :issue_states, dependent: :destroy

  def self.current_id=(id)
    Thread.current[:tenant_id] = id
  end

  def self.current_id
    Thread.current[:tenant_id]
  end
end
