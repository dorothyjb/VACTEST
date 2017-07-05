module Rms::Reports
  class FTE
    # Class Object to generate an FTE (Full Time Employee) Report.
    # Example Usage:
    #   fte_report = Rms::Reports::FTE.new
    #   File.open('foo.pdf') { |f| f.write fte_report.pdf }
    #   File.open('foo.xls') { |f| f.write fte_report.xls }
    #
    #   content = fte_report.pdf
    #   send_data content, filename: fte_report.filename, 
    #                      filetype: fte_report.filetype,
    #                      disposition: 'attachment'

    # Filename associated with the generated document. (Includes dates)
    attr_reader :filename

    # Filetype associated with the generated document. (MIME type)
    attr_reader :filetype

    # Creates a new FTE Report Object
    def initialize
      @empftes = Bvadmin::Employee.emp_fte_report
      @cur_pp = Bvadmin::Payperiod.cur_pp.first
      @next_pp = Bvadmin::Payperiod.next_pp.first
      @fte_losses = Bvadmin::Employee.fte_losses(@cur_pp.startdate, @cur_pp.startdate)
      @fte_new_hires = Bvadmin::EmployeeApplicant.fte_new_hires(@next_pp.startdate, @next_pp.enddate)

      @payperiod = @cur_pp.payperiod
      @pp_startdate = @cur_pp.startdate.strftime("%m/%d/%Y")
      @pp_enddate = @cur_pp.enddate.strftime("%m/%d/%Y")
      @eod_date = @next_pp.startdate.next_week(:monday).strftime("%m/%d/%Y")
      @loss_date = (@cur_pp.enddate + 1.weeks).strftime("%m/%d/%Y")
      @fte_total = @empftes.sum(:fte)
      @fte_ao_total = @fte_total + @fte_new_hires.count - @fte_losses.count
      @board_total = @empftes.count + @fte_new_hires.count - @fte_losses.count

      @report = nil
      @filename = "fte-report-pp#{@payperiod}-#{@cur_pp.startdate.strftime('%Y-%m-%d')}-#{@cur_pp.enddate.strftime('%Y-%m-%d')}"
      @filetype = 'application/binary'
    end

    # Generates an FTE report in XLS format.
    # Returns the binary XLS document.
    def xls
      header = [ "PP #{@payperiod}", '', "Pay Period #{@payperiod} Ended #{@pp_enddate}" ]

      @report = Rms::Export::XLSSpreadsheet.new('Latest FTE Report', header)
      @filename = "#{@filename}.xls"
      @filetype = 'application/vnd.ms-excel'

      @report.add_entry [ 'GD', 'ST', 'NAME', 'HRS', 'FTEE' ], @report.format.bold

      generate_ftes

      @report.add_blank
      @report.add_entry [ '', '', '', 'FTE', @fte_total ], @report.format.bold

      @report.add_blank
      @report.add_entry [ '', '', "New Hires Added PP #{@payperiod+1} EOD #{@eod_date}" ], @report.format.bold

      generate_fte_new_hires
      
      @report.add_blank
      @report.add_entry [ '', '', "Losses Subtracted PP #{@payperiod} a/o #{@loss_date}" ], @report.format.bold

      generate_fte_losses

      @report.add_blank
      @report.add_entry [ '', '', "TOTAL FTE A/O #{@loss_date}", '', @fte_ao_total ]
      @report.format_entry [2,3,4], @report.format.highlight

      @report.add_blank 2
      @report.add_entry [ '', '', "Total Employees on board as of #{@loss_date}", '', @board_total ]
      @report.format_entry [2,3,4], @report.format.highlight

      @report.process.string
    end

    # Generates an FTE report in PDF format.
    # Returns the binary PDF document.
    def pdf
      header = [ 'GD', 'ST', 'NAME', 'HRS', 'FTEE' ]

      @report = Rms::Export::PDFTableWriter.new("FTE Report for PP#{@payperiod}/#{@cur_pp.startdate.strftime("%Y")}", header)
      @filename = "#{@filename}.pdf"
      @filetype = 'application/pdf'

      @report.column_widths = [ 40, 40, 300, 40, 40, 40 ]

      @report.text "Begins #{@cur_pp.startdate.strftime("%A, %B %d")}, and ends #{@cur_pp.enddate.strftime("%A, %B %d")}.", align: :center, size: 12
      @report.move_down 20

      generate_ftes
      @report.draw_table :keep_header

      @report.text "Total FTE: <b>#{@fte_total}</b>", size: 12, align: :right, inline_format: true
      @report.move_down 20

      @report.text "New Hires Added PP #{@payperiod+1} EOD #{@eod_date}", size: 16, align: :center
      generate_fte_new_hires
      @report.draw_table :keep_header
      @report.move_down 20

      @report.text "Losses Subtracted PP #{@payperiod} a/o #{@loss_date}", size: 16, align: :center
      generate_fte_losses
      @report.draw_table :keep_header
      @report.move_down 10

      @report.text "TOTAL FTE A/O #{@loss_date}: <b>#{@fte_ao_total}</b>", align: :right, inline_format: true
      @report.move_down 5
      @report.text "Total Employees on board as of #{@loss_date}: <b>#{@board_total}</b>", align: :right, inline_format: true

      @report.render
    end

    private

    # Loops through the list of employees and writes them to the report. (internal function)
    def generate_ftes
      if @empftes.empty?
        @report.add_entry [ '', '', 'NONE' ]
      else
        @empftes.each_with_index do |emp, idx|
          @report.add_entry [ emp.grade, emp.step, emp.name, emp.fte*80, emp.fte, idx+1 ]
        end
      end
    end

    # Loops through the list of new hires and writes them to the report. (internal function)
    def generate_fte_new_hires
      if @fte_new_hires.empty?
        @report.add_entry [ '', '', 'NONE' ]
      else
        @fte_new_hires.each_with_index do |emp, idx|
          @report.add_entry [ emp.grade, emp.step, emp.name, 80, 1, idx+1 ]
        end
      end
    end

    # Loops through the list of leaving employees and writes them to the report.
    def generate_fte_losses
      if @fte_losses.empty?
        @report.add_entry [ '', '', 'NONE' ]
      else
        @fte_losses.each_with_index do |emp, idx|
          @report.add_entry [ emp.grade, emp.step, emp.name, 80, 1, idx+1 ]
        end
      end
    end
  end
end
