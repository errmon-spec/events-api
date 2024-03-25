# frozen_string_literal: true

logger = SemanticLogger[Rack::Timeout]
logger.level = :error

Rack::Timeout::Logger.logger = logger
