class Bvadmin::RmsOrgDivision < Bvadmin::RmsOrgInformation
  has_many :branches, foreign_key: :parent_id, class_name: Bvadmin::RmsOrgBranch
end
