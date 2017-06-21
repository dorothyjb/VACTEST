class Bvadmin::RmsRolePermission < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ROLE_PERMISSIONS"
  self.primary_key = :permission_id
end
