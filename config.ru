# frozen_string_literal: true

require_relative 'time_controller'

ROUTES = {
  '/time' => TimeController.new
}.freeze

use Rack::Reloader
use Rack::ContentType, 'text/plain'

run Rack::URLMap.new(ROUTES)
