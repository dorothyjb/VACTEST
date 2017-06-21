class CreateRmsUsers < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_USERS', primary_key: :user_id do |t|
      t.index :user_id

      t.string :email, limit: 60, index: true, null: false
      t.string :name, limit: 120, index: true, null: false
    end
  end
end
