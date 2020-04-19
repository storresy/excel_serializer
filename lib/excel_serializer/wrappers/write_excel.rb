module ExcelSerializer
  module Wrappers
    class WriteExcel
      # This is the wrapper for WriteExcel gem
      
      def initialize(file_path)
        @write_excel = ::WriteExcel.new(file_path)
      end

      def add_worksheet(sheet_name)
        WorkSheet.new(@write_excel, sheet_name)
      end

      def write(sheet_name, row)
        raise 'Not implemented'
      end

      def save
        @write_excel.close
      end

      def self.file_extension
        '.xls'
      end

      class WorkSheet
        def initialize(write_excel, sheet_name)
          @write_excel = write_excel
          @worksheet = @write_excel.add_worksheet(sheet_name)
        end

        def write(row, column, value)
          @worksheet.write(row, column, value)
        end
      end

    end
  end
end
