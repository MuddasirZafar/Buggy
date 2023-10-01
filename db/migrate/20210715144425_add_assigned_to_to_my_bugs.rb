class AddAssignedToToMyBugs < ActiveRecord::Migration[6.1]
  def change
    add_column :my_bugs, :assigned_to, :integer
  end
end
