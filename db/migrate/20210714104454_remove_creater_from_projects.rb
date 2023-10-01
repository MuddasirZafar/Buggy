class RemoveCreaterFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :creater, :integer
  end
end
