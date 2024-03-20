# frozen_string_literal: true

module V1
  class IngressController < ApplicationController
    include ProjectAuthenticatable

    def create
      result = ItemQueueManager.add(current_project, create_params.to_unsafe_h)

      if result.failure?
        errors = result.failure.errors.to_h
        render json: { errors: }, status: :unprocessable_entity
      else
        head :accepted
      end
    end

    private

    def create_params
      params.permit(:library, :revision, :level, :type, :message, :stack_trace)
    end
  end
end
