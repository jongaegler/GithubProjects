class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :user_name
      t.index :user_name
      t.string :github_url
      t.integer :stars

      t.timestamps
    end
  end
end
