require "excel_serializer/version"

module ExcelSerializer
  class Error < StandardError; end
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
