require 'rack'
require_relative 'timestamp'

class App
  def call(env)
    @env = env

    if valid_path?
      timestamp = TimeStamp.new(request.params["format"])

      if timestamp.has_invalid?
        rack_respone(:bad_request, "Unknown time format [#{timestamp.invalid}]")
      else
        rack_respone(:ok, timestamp.format)
      end
    else
      rack_respone(:not_found, "Page not found")
    end
  end

  private

  def rack_respone(response_msg, body)
    [
      Rack::Utils.status_code(response_msg),
      {"Content-Type" => "text/html"},
      [body],
    ]
  end

  def request
    @request = Rack::Request.new(@env)
  end

  def valid_path?
    request.path == '/time'
  end
end
