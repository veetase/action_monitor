module ActionMonitor
  class Configuration
    attr_accessor :app_name, :log_path, :producer_type, :current_user_identfier,
                  :resource_identfier

    def initialize
      # default configurations
      @log_path = 'log/action_monitor.log'
      @producer_type = 'file'
      @resource_identfier = 'tracking_resource_identfier'
    end
  end
end
