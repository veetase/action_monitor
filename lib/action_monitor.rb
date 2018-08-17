module ActionMonitor
  extend ActiveSupport::Concern

  class_methods do
    # params:
    #   actions(Array): 动作的类型，只支持[:create, :delete, update: []],
    #   如 track [:create, :delete, update: [:price, :publish_at]
    def track(*actions)
      actions.each do |action|
        if action.is_a?(Symbol) || action.is_a?(String)
          case action.to_s.downcase
          when 'create'
            after_create -> { track_action('create') }
          when 'destroy'
            after_destroy -> { track_action('destroy') }
          end
        elsif action.is_a?(Hash) && action.keys.map(&:to_s) == ['update']
          columns = action.values.flatten
          after_save do
            columns.each do |column|
              track_action_update(column.to_s, try("#{column}_was"), try(column))
            end
          end
        end
      end
    rescue StandardError => e
      puts e.inspect
    end
  end

  def track_action(action)
    log_action action: action
  end

  def track_action_update(column_name, old_value, new_value)
    return nil if new_value == old_value
    meta_data = { 
      action: 'update',
      content: column_name,
      status: new_value,
      old_status: old_value
    }

    log_action meta_data
  end

  def tracked_app_name
    @app_name ||= Settings.dji_track_logger.app_name || Rails.application.class.to_s
  end

  def track_client_id
    return @client_id if @client_id
    current_user_identfier = Settings.dji_track_logger.current_user_identfier
    @client_id = current_user_identfier ? eval(current_user_identfier) : try(:current_user).try(:id)
  end

  def log_action meta_data
    track_logger.tagged(action_name) do
      track_logger.info(
        key: "#{tracked_app_name}_#{self.class}",
        client_id: track_client_id,
        meta_data: meta_data,
        resource_id: try(:monitor_resource_id) || try(:id)
      )
    end
  end

  def track_logger
    return @track_logger if @track_logger
    # 默认file类型
    type = Settings.dji_track_logger.type || 'file'
    path = Settings.dji_track_logger.path || 'log/monitor.log'

    case type
    when 'file'
      @api_logger = LogStashLogger.new(
        type: :file,
        path: path,
        formatter: :json_lines,
        sync: true
      )
    end
  end
end
