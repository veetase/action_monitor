require 'action_monitor/producer'
require 'action_monitor/tracker'
module ActionMonitor
  PRODUCER_TYPE_FILE = 'file'.freeze

  SETTINGS = Settings.try(:action_monitor)
  CONFIG = {
    app_name: SETTINGS.try(:app_name) || Rails.application.class.to_s,
    log_path: SETTINGS.try(:log_path) || 'log/monitor.log',
    producer_type: SETTINGS.try(:producer_type) || PRODUCER_TYPE_FILE,
    current_user_identfier: SETTINGS.try(:current_user_identfier),
    resource_identfier: SETTINGS.try(:resource_identfier) || 'id'
  }.freeze
end

ActiveSupport.on_load :active_record do
  include ActionMonitor::Traker
end
