require 'producer/logger'
module ActionMonitor
  class Producer
    def self.allocate
      case ActionMonitor::CONFIG[:producer_type]
      when PRODUCER_TYPE_FILE
        return ActionMonitor::Logger.new
      end
    end
  end
end
