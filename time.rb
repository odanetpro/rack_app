# frozen_string_literal: true

class Time
  VALID_PARAMS = %w[year month day hour minute second].freeze

  def call(env)
    query_string = Rack::Request.new(env).query_string
    datetime_params = get_datetime_params(get_params(query_string))
    unknown_datetime_params = get_unknown_datetime_params(datetime_params)

    if unknown_datetime_params.size.positive? || datetime_params.size.zero?
      [400, { 'Content-Type' => 'text/plain' }, ["Unknown time format #{unknown_datetime_params}"]]
    else
      [200, { 'Content-Type' => 'text/plain' }, [date_time(datetime_params)]]
    end
  end

  private

  def get_params(query_string)
    Rack::Utils.parse_query(query_string)
  end

  def get_datetime_params(params)
    format = params['format']
    format ? format.split(',') : []
  end

  def get_unknown_datetime_params(params)
    params.difference(VALID_PARAMS)
  end

  def date_time(datetime_params)
    date_set = { 'year' => '%Y', 'month' => '%m', 'day' => '%d' }
    time_set = { 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }

    date_format = datetime_params.map { |param| date_set[param] }.compact.join('-')
    time_format = datetime_params.map { |param| time_set[param] }.compact.join(':')

    Time.now.strftime("#{date_format} #{time_format}".strip)
  end
end
