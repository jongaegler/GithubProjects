class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :user_id
      t.string :github_url
      t.integer :stars

      t.timestamps
    end
  end
end
