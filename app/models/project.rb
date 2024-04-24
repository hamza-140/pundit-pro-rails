class Project < ApplicationRecord
  has_many :bugs, dependent: :destroy
  validates :name, presence: true
  validates :created_by, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  has_many :project_users, dependent: :destroy, inverse_of: :project
  has_many :users, through: :project_users
  accepts_nested_attributes_for :project_users, allow_destroy: true, reject_if: :all_blank

  accepts_nested_attributes_for :bugs, allow_destroy: true,
                                       reject_if: :all_blank
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "created_by", "description", "id", "id_value", "name", "updated_at"]
  end
  # def created_by
  #   # Return the value of the created_by attribute
  #   self[:created_by]
  # end
end
