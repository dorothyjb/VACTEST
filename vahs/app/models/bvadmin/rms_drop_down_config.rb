class Bvadmin::RmsDropDownConfig < Bvadmin::Record
  # This class represents Drop Down configurations to be used within the
  # RMS application for various drop-down fields. The purpose of this object
  # is to allow configuration of these drop downs from a database configuration
  # instead of hardcoded in the RMS Application codebase.

  self.table_name = "BVADMIN.RMS_DROP_DOWN_CONFIG"

  #####
  # Scope that returns a list that matches +table_id+
  # @return ActiveRecord::Relation
  # @param [String] The table_id to lookup by.
  scope :by_table, -> (table_id) { where(table_id: table_id) }

  #####
  # scope that returns a list that matches +table_id+ and +field_id+
  # @return ActiveRecord::Relation
  # @param [String] The table_id to lookup by.
  # @param [String] The field_id to lookup by.
  scope :by_table_and_field, -> (table_id, field_id) { where(table_id: table_id, field_id: field_id) }

  #####
  # Description:
  #   method to read drop down options for a particular drop down categorized
  #   by the given +table_id+ and +field_id+. Optionally prepending options
  #   to the list.
  #
  # Usage:
  #   Bvadmin::RmsDropDownConfig.options_for('TABLE', 'FIELD')
  #     -- Returns a multi-dimensional array of list options to be used with
  #        options_for_select.
  #
  #   Bvadmin::RmsDropDownConfig.options_for('TABLE', 'FIELD', '': nil)
  #     -- Returns a multi-dimensional array of list options to be used with
  #        options_for_select. Prepending an empty selection option with the
  #        value of nil.
  #
  #   Bvadmin::RmsDropDownConfig.options_for('TABLE', 'FIELD', 'foo')
  #     -- Returns a multi-dimensional array of list options to be used with
  #        options_for_select. Prepending a 'foo' selection option with a
  #        value of 'foo'.
  #
  # @return array of two-value arrays.
  # @param [String, Symbol] The table_id value
  # @param [String, Symbol] The field_id value
  # @param [String, Hash] Value(s) to prepend to the resulting array.
  def self.options_for table_id, field_id, extra = nil
    table_id = table_id.to_s.upcase
    field_id = field_id.to_s.upcase

    rst = self.by_table_and_field(table_id, field_id).collect { |v| [ v.content, v.value ] }

    unless extra.nil?
      if extra.is_a?(Hash)
        rst.unshift extra.to_a
      elsif extra.is_a?(String)
        rst.unshift [ extra, extra ]
      end
    end

    rst
  end
end
