class TimeStamp
  FORMATS = { 'year' => '%Y',
              'month' => '%m',
              'day' => '%d',
              'hour' => '%H',
              'second' => '%S' }.freeze

  def initialize(params)
    @params = params.split(',')
  end

  def has_invalid?
    invalid_params.any?
  end

  def invalid
    invalid_params.join(', ')
  end

  def format
    Time.now.strftime(valid_params.join('-'))
  end

  private

  def valid_params
    @params.map { |param| FORMATS.fetch(param, nil) }.compact
  end

  def invalid_params
    @params.reject { |param| FORMATS.include?(param) }
  end
end
