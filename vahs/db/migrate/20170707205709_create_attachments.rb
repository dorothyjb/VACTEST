class CreateAttachments < ActiveRecord::Migration
  def change
    create_table 'BVADMIN.RMS_ATTACHMENTS' do |t|
      t.date :date, null: false
      t.string :filename, null: false, limit: 100
      t.string :filetype, null: false, limit: 100
      t.binary :filedata, null: false
      t.string :attachment_type, null: false, limit: 100
      t.belongs_to :employee, index: true
      t.string :notes, limit: 200
    end
  end
end
