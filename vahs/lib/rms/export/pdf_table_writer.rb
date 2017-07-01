module Rms::Export
  class PDFTableWriter < Prawn::Document
    attr_reader :format
    attr_writer :column_widths

    def initialize name, header
      super(top_margin: 30)

      @header = header
      @data = [header]
      @format = OpenStruct.new(bold: nil, highlight: nil)
      @column_widths = nil

      text "<b><u>#{name}</u></b>", align: :center, size: 24, inline_format: true
    end

    def add_entry entry, fmt=nil
      @data << entry
    end

    def draw_table new_header=:keep_header
      if @column_widths
        table @data, header: true, position: :center, column_widths: @column_widths
      else
        table @data, header: true, position: :center
      end

      if new_header.is_a?(Array)
        @data = [new_header]
        @header = new_header
      elsif new_header == :keep_header
        @data = [@header]
      else
        @data = []
      end

      move_down 20
    end
  end
end
