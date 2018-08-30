class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.datetime :login_at

      t.timestamps null: false
    end
  end
end
