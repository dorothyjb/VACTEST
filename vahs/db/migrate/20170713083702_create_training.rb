class CreateTraining < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.TRAINING' do |t|
      t.string :user_id, limit: 6, null: false
      t.string :class_name, limit: 60
      t.date :class_date
    end

    add_index 'BVADMIN.TRAINING', :user_id
  end
end
