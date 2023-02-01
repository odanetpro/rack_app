# frozen_string_literal: true

class DateTimeService
  VALID_PARAMS = %w[year month day hour minute second].freeze
  DATE_SET = { 'year' => '%Y', 'month' => '%m', 'day' => '%d' }.freeze
  TIME_SET = { 'hour' => '%H', 'minute' => '%M', 'second' => '%S' }.freeze

  Result = Struct.new(:date_time, :error_message) do
    def success?
      !!date_time
    end
  end

  def initialize(params)
    @params = params
  end

  def call
    unknown_params = get_unknown_params(@params)

    if unknown_params.size.positive? || @params.size.zero?
      Result.new(nil, "Unknown time format #{unknown_params}")
    else
      Result.new(date_time(@params), nil)
    end
  end

  private

  def get_unknown_params(params)
    params.difference(VALID_PARAMS)
  end

  def sort_params(params)
    VALID_PARAMS.select { |param| params.any?(param) }
  end

  def date_time(params)
    sorted_params = sort_params(params)

    date_format = sorted_params.map { |param| DATE_SET[param] }.compact.join('-')
    time_format = sorted_params.map { |param| TIME_SET[param] }.compact.join(':')

    Time.now.strftime("#{date_format} #{time_format}".strip)
  end
end
