module UserEventLogger
  module UserEventLoggerMixin
    def log_user_event(name, destination_url = nil, extra_data = nil, options = {})
      event = UserEvent.create(:source_url => request.path,
       :destination_url => destination_url,
       :remote_ip => request.remote_ip,
       :logged_at => Time.now,
       :extra_data => extra_data,
       :event_type => name,
       :user_id => logged_in? ? current_user.id : nil )
      if !options.empty?
        options.each do |key, value|
          event.send("#{key.to_s}=", value)
        end
        event.save!
      end
    end
  end
end
