module UserEventLogger
  module UserEventLoggerViewHelper
    def log_user_event(name, destination_url = nil, extra_data = nil, options = {})
      returning "" do |result|
        event = UserEvent.create(:source_url => request.path,
         :user => current_user,
         :destination_url => destination_url,
         :remote_ip => request.remote_ip,
         :logged_at => Time.now,
         :extra_data => extra_data,
         :event_type => name
        )
        if !options.empty?
          options.each do |key, value|
            event.send("#{key.to_s}=", value)
          end
          event.save!
        end
      end
    end
  end
end