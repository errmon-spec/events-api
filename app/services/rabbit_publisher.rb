# frozen_string_literal: true

module RabbitPublisher
  mattr_accessor :adapter, default: SneakersAdapter.new

  class << self
    delegate :publish, to: :adapter
  end
end
