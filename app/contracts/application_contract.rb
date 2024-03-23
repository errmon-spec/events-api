# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :'pt-BR'
  config.messages.backend = :i18n

  def self.call(...)
    new.call(...)
  end
end
