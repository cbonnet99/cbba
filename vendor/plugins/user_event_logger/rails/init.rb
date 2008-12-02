require "view_helpers" 
require "user_event_logger"
ActionView::Base.send :include, UserEventLogger::UserEventLoggerViewHelper
ActionController::Base.send :include, UserEventLogger::UserEventLoggerMixin

path = File.join(File.dirname(__FILE__), '..', 'lib', 'models')
$LOAD_PATH << path
ActiveSupport::Dependencies.load_paths << path
ActiveSupport::Dependencies.load_once_paths.delete(path)

