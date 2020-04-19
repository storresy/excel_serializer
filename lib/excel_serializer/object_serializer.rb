module ExcelSerializer
  module ObjectSerializer
    extend ActiveSupport::Concern
    include Writer

    included do
      attr_accessor :resources
    end

    class_methods do
      def attributes(*attributes_list)
        self.attributes_to_serialize ||= []
        self.attributes_to_serialize += attributes_list
      end

      def belongs_to(relation, serializer: nil)
        self.included_relations ||= {}
        self.included_relations[relation.to_s] = {
          method: relation,
          serializer: (serializer || relation_serializer(relation))
        }
      end

      def compute_headers
        if computed_headers.blank?
          self.computed_headers ||= []
          self.attributes_to_serialize.each do |attribute|
            self.computed_headers << attribute.to_s.humanize # TODO: translate attribute
          end
        end
        computed_headers
      end

      private
      
      def relation_serializer(relation)
        "#{relation.to_s.singularize.camelcase}ExcelSerializer"
      end
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
        write('Main', single_resource_all_info(resource))
      end 
      close_workbook
    end

    def object
      @object
    end

    def single_resource_all_info(resource)
      all_info = single_resource_info(resource)
      self.class.included_relations.each do |key, hash|
        all_info += hash[:serializer].constantize.new(nil).single_resource_info(
          resource.send(hash[:method])
        )
      end
      all_info
    end

    def single_resource_info(resource)
      self.object= resource
      self.class.attributes_to_serialize.map do |attribute|
        if self.respond_to?(attribute)
          self
        else
          resource
        end.send(attribute)
      end
    end

    def headers
      @headers ||= compute_headers
    end

    def compute_headers
      @headers = self.class.compute_headers
      self.class.included_relations.each do |key, hash|
        @headers += hash[:serializer].constantize.compute_headers
      end
      @headers
    end

    private

    def object=(object)
      @object = object
    end
  end
end
