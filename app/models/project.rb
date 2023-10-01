class Project < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_many :my_bugs , dependent: :destroy

  belongs_to :user
  has_many :users_projects
  has_many :users, through: :users_projects
end
