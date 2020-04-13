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
      sheet_hash = sheet(sheet_name)
      current_sheet = sheet_hash[:sheet]
      self.class.attributes_to_serialize.each_with_index do |attribute, current_column|
        current_sheet.write(0, current_column, attribute)
      end
    end

    def current_excel
      return @current_excel if @current_excel.present?
      @current_excel = wrapper.new(file_path)
    end

    def write(sheet_name, row)
      sheet_hash = sheet(sheet_name)
      current_sheet = sheet_hash[:sheet]
      current_row = (sheet_hash[:row_counter] += 1)
      row.each_with_index do |value, current_column|
        current_sheet.write(current_row, current_column, value)
      end
    end

    def sheet(sheet_name)
      @sheets ||= {}
      @sheets[sheet_name]= worksheet(sheet_name) if @sheets[sheet_name].blank? 
      @sheets[sheet_name]
    end


    def worksheet(sheet_name)
      { 
        sheet: current_excel.add_worksheet(sheet_name),
        row_counter: 0
      }
    end

    def file_path=(file_path)
      if file_path.blank? 
        @file_path = "/tmp/#{SecureRandom.uuid}.xls"
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
