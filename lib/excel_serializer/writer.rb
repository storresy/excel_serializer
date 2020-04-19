module ExcelSerializer
  module Writer
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :attributes_to_serialize
      end
    end

    private

    def single_resource_info(resource)
      self.class.attributes_to_serialize.map do |attribute|
        if self.respond_to?(attribute)
          self
        else
          resource
        end.send(attribute)
      end
    end

    def add_headers(sheet_name)
      sheet(sheet_name).write_headers(self.class.attributes_to_serialize)
    end

    def current_excel
      return @current_excel if @current_excel.present?
      @current_excel = wrapper.new(file_path)
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
        @file_path = "/tmp/#{SecureRandom.uuid}#{wrapper.file_extension}"
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

    def wrapper
      ::ExcelSerializer::Wrappers::WriteExcel
    end
  end
end
