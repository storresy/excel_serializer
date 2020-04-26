module ExcelSerializer
  module Writer
    extend ActiveSupport::Concern

    private

    def add_headers(sheet_name)
      sheet(sheet_name).write_headers(headers)
    end

    def current_excel
      return @current_excel if @current_excel.present?
      @current_excel = adapter.new(file_path)
    end

    def write(sheet_name, row)
      sheet(sheet_name).write_row(row)
    end

    def sheet(sheet_name)
      @sheets ||= {}
      @sheets[sheet_name]= worksheet(sheet_name) if @sheets[sheet_name].blank? 
      @sheets[sheet_name]
    end

    def worksheet(sheet_name)
      ExcelSerializer::Worksheet.new(current_excel, sheet_name)
    end

    def file_path=(file_path)
      if file_path.blank? 
        @file_path = "/tmp/#{SecureRandom.uuid}#{adapter.file_extension}"
      else
        @file_path= file_path
      end
    end

    def file_path
      @file_path
    end

    def close_workbook
      current_excel.save
      return file_path
    end

    def adapter
      case self.class.current_config.excel_adapter
      when :write_excel
        ::ExcelSerializer::Adapters::WriteExcel
      else
        raise "Invalid excel writer adapter"
      end
    end
  end
end
