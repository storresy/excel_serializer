module ExcelSerializer
  module HeadersTranslator
    extend ActiveSupport::Concern

    class_methods do
      def compute_headers
        if computed_headers.blank?
          self.computed_headers ||= []
          self.attributes_to_serialize.each do |attribute|
            self.computed_headers << translate_attribute(attribute) # TODO: translate attribute
          end
        end
        computed_headers
      end

      def translation_key_base(translation_key_base)
        @translation_key_base = translation_key_base
      end

      def translate_attribute(attribute)
        case self.current_config.translation_adapter
        when :i18n
          i18n_translation(attribute)
        when :humanize
          humanize(attribute)
        else
          raise "Invalid translations adapter"
        end
      end

      def i18n_translation(attribute)
        I18n.t("#{translation_base}.#{attribute}")
      end

      def humanize(attribute)
        attribute.to_s.humanize
      end

      def translation_base
        return @translation_key_base if @translation_key_base.present?
        obj_name = self.name.sub('ExcelSerializer','').underscore
        @translation_key_base = "activerecord.attributes.#{obj_name}"
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
  end
end
