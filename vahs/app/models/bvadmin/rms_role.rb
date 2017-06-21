class Bvadmin::RmsRole < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ROLES"
  self.primary_key = :role_id

  has_and_belongs_to_many :rms_users, join_table: 'BVADMIN.RMS_ROLES_USERS',
    association_foreign_key: 'user_id', foreign_key: 'role_id'

end
