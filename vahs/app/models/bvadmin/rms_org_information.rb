class Bvadmin::RmsOrgInformation < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ORG_INFORMATION"

  belongs_to :rms_org_code

  def self.dropdown
    [ '' ] + where('name is not null').collect { |n| [ n[:name], n[:id] ] }
  end

  def total_fte
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:ftee).to_f
  end

  def total_vacant
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:vacant).to_i
  end

  def total_on_board
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id} and status = 'ON BOARD'#{sql}", vars).sum(:number_of_personnel).to_i
  end

  def total_on_board_other
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:other).to_i
  end

  def total_rotation
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:rotation).to_i
  end

  def funded_positions
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:funded_position).to_i
  end

  def unfunded_positions
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:unfunded_position).to_i
  end

  def total_incoming
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:incoming).to_i
  end

  def total_departing
    sql, vars = get_applied_filters

    Bvadmin::WorkforceRoster.where("#{type_id} = #{self.id}#{sql}", vars).sum(:departing).to_i
  end

  def filters= filters
    @filters = filters
  end

private
  def get_applied_filters
    @filters ||= {}

    filter_vars = {}
    sql = ""

    if @filters[:official_titles]
      sql += " and (official_title in (:official_titles))"
      filter_vars[:official_titles] = @filters[:official_titles]
    end

    if @filters[:unofficial_titles]
      sql += " and (unofficial_title in (:unofficial_titles))"
      filter_vars[:unofficial_titles] = @filters[:unofficial_titles]
    end

    if @filters[:series]
      sql += " and (series in (:series))"
      filter_vars[:series] = @filters[:series]
    end

    if @filters[:grades]
      sql += " and (grade in (:grades))"
      filter_vars[:grades] = @filters[:grades]
    end

    if @filters[:eod_start].present?
      sql += " and (eod >= :eod_start)"
      filter_vars[:eod_start] = parse_date(@filters[:eod_start])
    end

    if @filters[:eod_end].present?
      sql += " and (eod <= :eod_end)"
      filter_vars[:eod_end] = parse_date(@filters[:eod_end])
    end

    if @filters[:status]
      sql += " and (status in (:statuses))"
      filter_vars[:statuses] = @filters[:status]
    end

    [ sql, filter_vars ]
  end

  def type_id
    {
      'Bvadmin::RmsOrgOffice' => 'office',
      'Bvadmin::RmsOrgDivision' => 'division',
      'Bvadmin::RmsOrgBranch' => 'branch',
      'Bvadmin::RmsOrgUnit' => 'unit',
    }.fetch(self.class.to_s, 'id')
  end

  def parse_date in_date
    out_date = ''

    if %r{^(?<month>\d{2})(?<day>\d{2})(?<year>\d{4,})|
           (?<month>\d{1,2})/(?<day>\d{1,2})/(?<year>\d{4,})|
           (?<year>\d{4,})-(?<month>\d{1,2})-(?<day>\d{1,2})$}x =~ in_date

      out_date = begin
                   Date.new(year.to_i, month.to_i, day.to_i)
                 rescue ArgumentError
                   ''
                 end
    end

    out_date
  end
end
