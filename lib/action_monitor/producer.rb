module ActionMonitor
  class Producer
    def self.allocate
      case ActionMonitor.configuration.producer_type
      when 'file'
        return ActionMonitor::Logger.new
      end
    end
  end
end
