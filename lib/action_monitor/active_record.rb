ActiveSupport.on_load :active_record do
  include ActionMonitor
end