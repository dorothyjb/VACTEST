class Bvadmin::RmsUser < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_USERS"
  self.primary_key = :user_id

  has_and_belongs_to_many :rms_roles, join_table: 'BVADMIN.RMS_ROLES_USERS',
    association_foreign_key: 'role_id', foreign_key: 'user_id'

  # TODO / XXX: optimize to scope.
  def has_role? *roles
    names = *roles.collect { |r| r.to_s.downcase }
    rst = rms_roles.where('LOWER(name) in (:names)', names: names)
    !rst.empty?
  end
end
