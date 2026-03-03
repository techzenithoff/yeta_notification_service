# Gems
require "faraday"
require "json"

require_relative "lib/version"
require_relative "lib/configuration"
require_relative "lib/exceptions"
require_relative "lib/interceptor"
require_relative "lib/client"

module ArolitecSms
  
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
