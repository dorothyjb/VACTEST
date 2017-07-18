# this has mostly moved to lib/rms/export/xls_spreadsheet
# if you uncomment the docket/analysis controllers, you will
# need this however.
=begin
module XLSHelper
  extend ActiveSupport::Concern

  class XLSSpreadsheet
    attr_accessor :data, :book, :sheet, :format

    def initialize name, header
      @data = StringIO.new
      @book = Spreadsheet::Workbook.new
      @sheet = @book.create_worksheet(name: name)
      @format = Spreadsheet::Format.new({weight: :bold})
      @index = 0

      add_entry header, @format
    end

    def resize_columns entry
      entry.each_with_index do |e, i|
        len = e.to_s.length + 5
        @sheet.column(i).width = len if @sheet.column(i).width < len
      end
    end

    def total_columns
      @sheet.row(0).length
    end

    def add_entry entry, fmt=nil
      resize_columns entry
      sheet.row(@index).concat entry
      sheet.row(@index).default_format = fmt unless fmt.nil?
      @index += 1
    end

    def process
      @book.write @data
      @data
    end
  end
end
=end
