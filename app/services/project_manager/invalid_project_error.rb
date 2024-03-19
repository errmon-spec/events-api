# frozen_string_literal: true

module ProjectManager
  class InvalidProjectError < StandardError
    def initialize(message, contract_result)
      super(message)
      @contract_result = contract_result
    end
  end
end
