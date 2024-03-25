# frozen_string_literal: true

class FlyRequestIdMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request_id = env['HTTP_X_REQUEST_ID']
    env['HTTP_X_REQUEST_ID'] = env['HTTP_FLY_REQUEST_ID'].presence if request_id.blank?

    @app.call(env)
  end
end
