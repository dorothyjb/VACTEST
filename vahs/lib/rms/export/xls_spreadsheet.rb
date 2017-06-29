module Rms::Export
  class XLSSpreadsheet
    attr_accessor :data, :book, :sheet, :format

    class Format
      attr_reader :bold, :highlight

      def initialize
        @bold = Spreadsheet::Format.new(weight: :bold)
        @highlight = Spreadsheet::Format.new(weight: :bold, color: :black,
                                             pattern_fg_color: :yellow,
                                             pattern: 1)
      end
    end

    def initialize name, header
      @data = StringIO.new
      @book = Spreadsheet::Workbook.new
      @sheet = @book.create_worksheet(name: name)
      @format = Format.new
      @index = 0

      add_entry header, @format.bold
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

    def add_blank cnt=1
      return if cnt < 1
      @index += cnt
    end

    def format_entry cols, fmt
      if cols.is_a? Array
        cols.each do |c|
          sheet.row(@index-1).set_format(c, fmt)
        end
      elsif cols.is_a? Fixnum
        sheet.row(@index-1).set_format(cols, fmt)
      elsif cols == :all
        sheet.row(@index-1).each_index do |c|
          sheet.row(@index-1).set_format(c, fmt)
        end
      elsif cols == :default
        sheet.row(@index-1).default_format = fmt
      end
    end

    def process
      @book.write @data
      @data
    end
  end
end
