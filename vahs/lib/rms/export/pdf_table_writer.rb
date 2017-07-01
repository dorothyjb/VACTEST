module Rms::Export
  class PDFTableWriter < Prawn::Document
    # Class Object to generate PDF documents that are mostly tabular data.
    # Example Usage:
    #   pdf = Rms::Export::PDFTableWriter.new("This is the Document Header", [ "A", "B", "C" ])
    #   pdf.add_entry [ "Apple", "Butter", "Cookie" ]
    #   pdf.draw_table
    #   contents = pdf.render

    # Column Widths; An Array of integers defining the width for each column.
    attr_writer :column_widths

    # Creates a new PDFTableWriter object
    # The <tt>name</tt> parameter is the document header.
    # The <tt>header</tt> parameter is the header row for the table.
    def initialize name, header
      super(top_margin: 30)

      @header = header
      @data = [header]
      @column_widths = nil

      text "<b><u>#{name}</u></b>", align: :center, size: 24, inline_format: true
    end

    # Adds a row to the table being generated
    # <tt>entry</tt> is expected to be an array, where each value within
    # the array is a value for that column.
    def add_entry entry
      @data << entry
    end

    # Draws the table as is. Then sets up for another table to be generated.
    # <tt>new_header</tt> can be an Array containing the new table header to be used.
    # <tt>new_header</tt> may also be the symbol <tt>:keep_header</tt> to ensure
    # that the current table header being used, continues to be used.
    # Any other value, will result in the next entry added to be used as the table header.
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
