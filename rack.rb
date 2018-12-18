require 'rack'
require_relative 'timestamp'

class App
  def call(env)
    @env = env

    if valid_path?
      timestamp = TimeStamp.new(query_string)

      if timestamp.bad_request?
        rack_respone(:bad_request, "Unknown time format [#{timestamp.unknown_list}]")
      else
        rack_respone(:ok, create_timestamp(timestamp.format))
      end
    else
      rack_respone(:not_found, "Page not found")
    end
  end

  private

  def rack_respone(response_msg, body)
    [
      status_code(response_msg),
      {"Content-Type" => "text/html"},
      [body],
    ]
  end

  def valid_path?
    Rack::Request.new(@env).path == '/time'
  end

  def status_code(msg)
    Rack::Utils.status_code(msg)
  end

  def query_string
    Rack::Request.new(@env).params["format"].split(',')
  end

  def create_timestamp(format)
    Time.now.strftime(format).to_s
  end
end
