require 'action_monitor/producer/logger'
require 'action_monitor/tracker'
require 'action_monitor/configuration'
module ActionMonitor
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

ActiveSupport.on_load :active_record do
  include ActionMonitor::Traker
end
