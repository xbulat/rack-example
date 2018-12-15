class TimeStamp
  FORMATS = %w[year month day hour minute second].freeze
  HTTP_CODES = { "OK" => 200, "BAD_REQUEST" => 400, "NOT_FOUND" => 404 }

  def call(env)
    handle_request(env)

    [
      answer_code,
      headers,
      body,
    ]
  end

  def handle_request(env)
    return unless valid_path?(env)

    query = query_string(env)
    answer = []
    unknown = []

    query.map do |q|
      if FORMATS.include?(q)
        answer << send("time_#{q}")
      else
        unk << q
      end
    end

    if unknown.any?
      @answer_code = HTTP_CODES["BAD_REQUEST"]
      @body = "Unknown time format [#{unk.join(', ')}]"
    else
      @answer_code = HTTP_CODES["OK"]
      @body = answer.join('-')
    end
  end

  private

  def valid_path?(env)
    unless env['REQUEST_PATH'] == '/time'
      @answer_code = HTTP_CODES["NOT_FOUND"]
      @body = "Page not found"
      false
    else
      true
    end
  end

  def body
    [@body]
  end

  def headers
    { "Content-Type" => "text/html" }
  end

  def query_string(env)
    env['QUERY_STRING'].split("=")[1].split(',')
  end
  
  def answer_code
    @answer_code || HTTP_CODES["OK"]
  end

  def time_year
    Time.now.strftime("%Y")
  end

  def time_month
    Time.now.strftime("%m")
  end

  def time_day
    Time.now.strftime("%d")
  end

  def time_hour
    Time.now.strftime("%H")
  end

  def time_minute
    Time.now.strftime("%M")
  end

  def time_second
    Time.now.strftime("%S")
  end
end
