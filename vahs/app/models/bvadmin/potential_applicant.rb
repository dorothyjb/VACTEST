class Bvadmin::PotentialApplicant < Bvadmin::Record
  self.table_name = "BVADMIN.POTENTIAL_APPLICANTS"

  scope :newsearch, -> (first, last) {
    if first.present? && last.present?
      where(<<-EOQ, "#{first.upcase}%", first, "#{last.upcase}%", last)
        (upper(fname) like ? or soundex(fname) = soundex(?)) and
        (upper(lname) like ? or soundex(lname) = soundex(?))
      EOQ
    elsif last.present?
      where(<<-EOQ, "#{last.upcase}%", last)
        (upper(lname) like ?) or (soundex(lname) = soundex(?))
      EOQ
    elsif first.present?
      where(<<-EOQ, "#{first.upcase}%", first)
        (upper(fname) like ?) or (soundex(fname) = soundex(?))
      EOQ
    else
      all
    end
  }
end
