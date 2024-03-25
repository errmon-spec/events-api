# frozen_string_literal: true

class FlyClientIpMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if true_client_ip = env['HTTP_FLY_CLIENT_IP']
      env['ORIGINAL_HTTP_X_FORWARDED_FOR'] = env['HTTP_X_FORWARDED_FOR']
      env['HTTP_X_FORWARDED_FOR'] = true_client_ip
    end

    @app.call(env)
  end
end
