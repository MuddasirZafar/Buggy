class ChangeTypeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :my_bugs, :type, :bug_type
  end
end
