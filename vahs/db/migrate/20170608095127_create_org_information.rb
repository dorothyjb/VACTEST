class CreateOrgInformation < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.ORG_INFORMATION' do |t|
      t.index :id

      t.string :office, limit: 50
      t.string :division, limit: 50
      t.string :branch, limit: 50
      t.string :unit, limit: 50
    end
  end
end
