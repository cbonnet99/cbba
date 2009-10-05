class AdminApplicationController < SecureApplicationController
  before_filter :admin_required

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "#{APP_CONFIG[:rake]} #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end
  
  protected
  
  def get_selected_user
    @selected_user = User.find_by_slug(params[:id])
  end

end