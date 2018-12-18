class TimeStamp
  FORMATS = { 'year' => '%Y',
              'month' => '%m',
              'day' => '%d',
              'hour' => '%H',
              'second' => '%S' }.freeze

  def initialize(query)
    @query = query
    @format = []
    @unknown = []
    parse!
  end

  def bad_request?
    @unknown.any?
  end

  def unknown_list
    @unknown.join(', ')
  end

  def format
    @format.join('-')
  end

  def parse!
    @query.map { |q| FORMATS.include?(q) ? @format << FORMATS.fetch(q) : @unknown << q }
  end
end
