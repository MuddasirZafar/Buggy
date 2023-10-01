class ChangeBugsTableName < ActiveRecord::Migration[6.1]
  def change
    rename_table :bugs, :my_bugs
  end
end
