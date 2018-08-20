require 'action_monitor/producer'
module ActionMonitor
  class Logger < ActionMonitor::Producer
    def initialize
      @logger = LogStashLogger.new(
        type: :file,
        path: ActionMonitor.configuration.log_path,
        formatter: :json_lines,
        sync: true
      )
    end

    def output(key, client_id, meta_data)
      @logger.info(
        key: key,
        client_id: client_id,
        meta_data: meta_data
      )
    end
  end
end
