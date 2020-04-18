module ExcelSerializer
  class Worksheet
    attr_accessor :sheet, :row_counter

    def initialize(current_excel, sheet_name)
      @sheet = current_excel.add_worksheet(sheet_name)
      @row_counter = 0
    end

    def write_row(row)
      row_index = @row_counter += 1
      row.each_with_index do |value, current_column|
        @sheet.write(row_index, current_column, value)
      end
    end

    def write_headers(headers)
      headers.each_with_index do |value, current_column|
        @sheet.write(0, current_column, value)
      end
    end
  end
end
