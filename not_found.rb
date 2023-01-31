# frozen_string_literal: true

class NotFound
  def call(_env)
    [
      404,
      { 'Content-Type' => 'text/plain' },
      ["404 - Page not found\n"]
    ]
  end
end
