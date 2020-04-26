module ExcelSerializer
  module Writer
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :attributes_to_serialize
        attr_accessor :included_relations
        attr_accessor :computed_headers
      end
    end

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
      ::ExcelSerializer::Adapters::WriteExcel
    end
  end
end
