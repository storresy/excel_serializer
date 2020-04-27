module ExcelSerializer
  module Adapters
    class WriteExcel
      # This is the adapter for WriteExcel gem
      
      def initialize(file_path)
        @write_excel = ::WriteExcel.new(file_path)
      rescue NameError => e
        raise ExcelAdapterNotFoundError.new('WriteExcel', 'writeexcel')
      end

      def add_worksheet(sheet_name)
        WorkSheet.new(@write_excel, sheet_name)
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
