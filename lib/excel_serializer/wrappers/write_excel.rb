module ExcelSerializer
  module Wrappers
    class WriteExcel
      # This is the wrapper for WriteExcel gem
      
      def initialize(file_path)
        @write_excel = ::WriteExcel.new(file_path)
      end

      def add_worksheet(sheet_name)
        @write_excel.add_worksheet(sheet_name)
      end

      def write(sheet_name, row)
        raise 'Not implemented'
      end

      def save
        @write_excel.close
      end

    end
  end
end
