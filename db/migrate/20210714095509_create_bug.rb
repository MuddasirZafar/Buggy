class CreateBug < ActiveRecord::Migration[6.1]
  def change
    create_table :bugs do |t|
      t.string :title, uniqueness: true
      t.datetime :deadline
      t.string :type
      t.string :status
      t.string :image
      t.text :description
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
  end
end
