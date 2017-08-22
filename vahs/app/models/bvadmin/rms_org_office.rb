class Bvadmin::RmsOrgOffice < Bvadmin::RmsOrgInformation
  has_many :divisions, foreign_key: :parent_id, class_name: Bvadmin::RmsOrgDivision
end
