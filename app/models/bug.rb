class Bug < ApplicationRecord
  belongs_to :user,optional:true
  belongs_to :project
  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :bug_type, presence: true, inclusion: { in: %w[feature bug] }
  validates :status, presence: true, inclusion: { in: %w[new started completed resolved] }
  mount_uploader :screenshot, ImageUploader
end
