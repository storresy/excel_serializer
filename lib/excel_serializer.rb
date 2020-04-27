require "excel_serializer/version"
require "excel_serializer/object_serializer"

module ExcelSerializer
  class ExcelAdapterNotFoundError < StandardError
    def initialize(class_name, gem_name)
      msg = "#{class_name} could not be found. Please ensure you have '#{gem_name}' gem installed or setup a different excel adapter"
      super(msg)
    end
  end
  class Config
    attr_accessor :excel_adapter, :translation_adapter

    def initialize(excel_adapter: :write_excel,
                    translation_adapter: :i18n)
      self.excel_adapter = excel_adapter
      self.translation_adapter = translation_adapter
    end
  end

  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield(self.config)
  end
end
