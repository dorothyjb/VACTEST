class CreateTraining < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.TRAINING', id: false do |t|
      t.string :user_id, limit: 6, index: true, null: false
      t.string :class_name, limit: 60
      t.date :class_date
    end
  end
end
