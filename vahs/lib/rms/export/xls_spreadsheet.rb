module Rms::Export
  class XLSSpreadsheet
    # Class Object to generate an XLS spreadsheet
    # Example Usage:
    #   xls = Rms::Export::XLSSpreadsheet.new "My Spreadsheet", [ 'A', 'B', 'C' ]
    #   xls.add_entry [ 'Apple', 'Butter', 'Cookie' ], xls.format.bold
    #   content = xls.process

    # various attributes, (that you really shouldn't need to access)
    attr_accessor :data, :book, :sheet

    # some 'pre-loaded' formats.
    attr_reader :format

    # Creates a new XLSSpreadsheet object
    # The <tt>name</tt> parameter is the name given to the worksheet.
    # The <tt>header</tt> parameter is used to prepopulate the first row of the spreadsheet.
    def initialize name, header
      @data = StringIO.new
      @book = Spreadsheet::Workbook.new
      @sheet = @book.create_worksheet(name: name)
      @format = OpenStruct.new(bold: Spreadsheet::Format.new(weight: :bold),
                               highlight: Spreadsheet::Format.new(weight: :bold, color: :black,
                                                                  pattern_fg_color: :yellow,
                                                                  pattern: 1))
      @index = 0

      add_entry header, @format.bold
    end

    # Returns the total number of columns in the first row.
    def total_columns
      @sheet.row(0).length
    end

    # Adds a row to the spreadsheet.
    # <tt>entry</tt> should be an Array of values to add to the row
    # <tt>fmt</tt> is an optional parameter that expects a Spreadsheet::Format object
    # You may use the <tt>format</tt> variable of this object to access to predefined formats.
    # Currently defined formats are: bold, and highlight.
    # Example:
    #   xls.add_entry [ 'foo', 'bar', 'baz' ], xls.format.bold
    #   xls.add_entry [ 'baz', 'bar', 'foo' ], xls.format.highlight
    def add_entry entry, fmt=nil
      resize_columns entry
      sheet.row(@index).concat entry
      sheet.row(@index).default_format = fmt unless fmt.nil?
      @index += 1
    end

    # Adds blank row(s)
    # The optional parameter <tt>cnt</tt> must be a value greater than or equal to one.
    def add_blank cnt=1
      return if cnt < 1
      @index += cnt
    end

    # Sets the format of the previous entry.
    # <tt>cols</tt> can be an Array of integer indicies to use. (Which columns to set the format on.)
    # <tt>fmt</tt> is a Spreadsheet::Format object. See add_entry for pre-defined formats.
    #
    # <tt>cols</tt> can also be a Fixnum (Integer value) to specify which column to set the format on.
    # In addition, <tt>cols</tt> may also be one of the symbols, <tt>:all</tt> or <tt>:default.</tt>
    # Where <tt>:all</tt> will attempt to loop through the columns of the given row and set format on
    # those columns. Where <tt>:default</tt> will set the default format for the given row to <tt>fmt</tt>.
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

    # Processes the information and generates the spreadsheet.
    # The return value is a StringIO object containing the binary
    # information of the 
    def process
      @book.write @data
      @data
    end

    private
    # Resizes columns based on the values within a given column.
    # <tt>entry</tt> is expected an array of values being appended
    # to the spreadsheet. (This is an internal function.)
    def resize_columns entry
      entry.each_with_index do |e, i|
        len = e.to_s.length + 5
        @sheet.column(i).width = len if @sheet.column(i).width < len
      end
    end
  end
end
