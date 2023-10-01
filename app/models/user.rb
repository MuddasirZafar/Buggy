class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :user_type, presence: true

  has_many :projects , dependent: :destroy
  has_many :my_bugs, dependent: :destroy

  has_many :users_projects
  has_many :projects, through: :users_projects 

  def developer?
    return user_type.eql?('developer')
  end
  
  def manager?
    return user_type.eql?('manager')
  end

  def qa?
    return user_type.eql?('qa')
  end
end
