class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # after_create :send_signup_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { manager: 0, quality_assurance: 1, developer: 2 }
  has_many :bugs, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true
  has_many :project_users
  has_many :projects, through: :project_users
  private

  def send_signup_email
    SendWelcomeEmailJob.perform_later(self.id)
  end
end
