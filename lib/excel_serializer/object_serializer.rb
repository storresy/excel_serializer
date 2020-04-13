module ExcelSerializer
  module ObjectSerializer
    extend ActiveSupport::Concern
    include Writer

    included do
      attr_accessor :resources
    end

    def initialize(resources, file_path: nil)
      self.file_path = file_path
      if resources.is_a?(ActiveRecord::Relation) or resources.is_a?(Array)
        self.resources = resources
      else
        self.resources = [resources]
      end
    end

    def excel_file
      add_headers('Main')
      method_name = 'each'
      if resources.is_a?(ActiveRecord::Relation)
        method_name = 'find_each'
      end
      resources.send(method_name) do |resource|
        self.object= resource
        write('Main', single_resource_info(resource))
      end 
      close_workbook
    end

    def object
      @object
    end

    class_methods do
      def attributes(*attributes_list)
        self.attributes_to_serialize ||= []
        self.attributes_to_serialize += attributes_list
      end
    end

    private

    def object=(object)
      @object = object
    end
  end
end
