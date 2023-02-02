# frozen_string_literal: true

require_relative 'date_time_service'

class TimeController
  def call(env)
    query = get_query(env)
    query_params = get_params(query)
    datetime_params = get_datetime_params(query_params)

    result = DateTimeService.new(datetime_params).call

    if result.success?
      [200, {}, [result.date_time]]
    else
      [400, {}, [result.error_message]]
    end
  end

  private

  def get_query(env)
    Rack::Request.new(env).query_string
  end

  def get_params(query)
    Rack::Utils.parse_query(query)
  end

  def get_datetime_params(params)
    params['format'] ? params['format'].split(',') : []
  end
end
