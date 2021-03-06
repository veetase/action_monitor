module ActionMonitor
  module Traker
    extend ActiveSupport::Concern
    class_methods do
      # params:
      #   actions(Array): 动作的类型，只支持[:create, :delete, update: []],
      #   如 track :create, :delete, :update 记录插入，删除，更新事件
      #   如 track :create, :delete, update: :price，记录插入，删除，指定行的更新事件
      #   如 track [:create, :delete, update: [:price, :publish_at]
      #   如 track [:create, :delete, update: {only: [:publish_at, :price]}
      #   如 track [:create, :delete, update: {except: :updated_at}
      def track(*actions)
        actions.each do |action|
          if action.is_a?(Symbol) || action.is_a?(String)
            case action.to_s.downcase
            when 'create'
              after_create -> { track_action('create') }
            when 'destroy'
              after_destroy -> { track_action('destroy') }
            when 'update'
              after_update -> { track_action('update') }
            end
          elsif action.is_a?(Hash) && action.keys.map(&:to_s) == ['update']
            columns = get_columns_to_track(action.values.first)
            after_update do
              columns.each do |column|
                track_action_update(column.to_s, try("#{column}_was"), try(column))
              end
            end
          end
        end
      rescue StandardError => e
        puts e.inspect
      end

      def get_columns_to_track(obj)
        columns = column_names.map(&:to_sym)
        columns_to_track = if obj.is_a? Hash
                             if obj[:only].present?
                               Array(obj[:only])
                             elsif obj[:except].present?
                               columns - Array(obj[:except])
                             else
                               []
                             end
                           else
                             Array(obj)
                           end

        columns & columns_to_track
      end
    end

    def track_action(action)
      produce action: action
    end

    def track_action_update(column_name, old_value, new_value)
      return nil if new_value == old_value
      meta_data = {
        action: 'update',
        content: column_name,
        status: new_value,
        old_status: old_value
      }

      produce meta_data
    end

    def track_client_id
      return @track_client_id if @track_client_id
      current_user_identfier = ActionMonitor.configuration.current_user_identfier
      @track_client_id = current_user_identfier ? eval(current_user_identfier) : try(:current_user).try(:id)
    end

    def producer
      @track_producer ||= ActionMonitor::Producer.allocate
    end

    def resource_id
      return @track_resource_id if @track_resource_id

      resource_identfier = ActionMonitor.configuration.resource_identfier.try(:to_sym)
      identfier = try(resource_identfier).try(:to_sym) || :id

      @track_resource_id = try(identfier)
    end

    def produce(meta_data)
      data = meta_data.merge(resource_id: resource_id)
      app_name = ActionMonitor.configuration.app_name || Rails.application.class
      producer.output("#{app_name}_#{self.class}", track_client_id, data)
    end
  end
end
