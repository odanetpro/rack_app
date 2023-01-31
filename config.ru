# frozen_string_literal: true

require_relative 'time'
require_relative 'not_found'

use Rack::Reloader

map '/time/' do
  run Time.new
end

run NotFound.new
