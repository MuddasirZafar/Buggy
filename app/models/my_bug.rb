class MyBug < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :bug_type, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  validates :project_id, presence: true
  validates :deadline, presence: true

  mount_uploader :image, AvatarUploader
  
  belongs_to :user
  belongs_to :project
end
