# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :cron_log, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "/var/log/cron_bam.log"

every 1.month, :at => "beginning of the month at 3am" do
  command "psql -U postgres be_amazing_production < script/reset_monthly_view_counts.sql"  
end

every 2.weeks do
  runner "TaskUtils.notify_unpublished_users"
end

every :sunday, :at => '12pm'  do
  rake "bam:count_published_items"
  runner "TaskUtils.send_weekly_admin_stats"
end

every 1.day, :at => "3am"  do
  runner "TaskUtils.send_offers_reminder"
  runner "TaskUtils.check_pending_payments"
  runner "TaskUtils.rotate_feature_ranks"
  runner "TaskUtils.mark_down_old_full_members"
  command "find /home/cyrille/backups/postgres* -type f -mtime +14 | xargs rm -Rf"
  command "find /home/cyrille/backups/assets-* -type f -mtime +14 | xargs rm -Rf"
  runner "TaskUtils.rotate_user_positions_in_subcategories"
  runner "TaskUtils.rotate_user_positions_in_categories"
  runner "TaskUtils.check_feature_expiration"
  runner "TaskUtils.check_expired_offers"
  runner "TaskUtils.charge_expired_features"
  command "cp --preserve=timestamps /etc/apache2/sites-available/be_amazing_staging /home/cyrille/backups/apache-be_amazing_staging"
  command "cp --preserve=timestamps /etc/apache2/sites-available/be_amazing /home/cyrille/backups/apache-be_amazing"
  command "cp --preserve=timestamps /etc/apache2/sites-available/redmine /home/cyrille/backups/apache-redmine"
  command "cp --preserve=timestamps /etc/nginx/sites-available/beamazing_staging /home/cyrille/backups/nginx-beamazing_staging"
  command "cp --preserve=timestamps /etc/nginx/sites-available/beamazing /home/cyrille/backups/nginx-beamazing"
  command "cp --preserve=timestamps /etc/nginx/www-server.key /home/cyrille/backups/"
  command "cp --preserve=timestamps /etc/nginx/beamazing.co.nz.pem /home/cyrille/backups/"
  command "cp --preserve=timestamps /etc/varnish/default.vcl /home/cyrille/backups/varnish-default.vcl"
  command "pg_dump -U postgres -d be_amazing_production > /home/cyrille/backups/bam-backup-`date +\\%Y-\\%m-\\%d`.sql", :output => {:error => '/var/log/cron_bam.log'}
  command "psql -U postgres be_amazing_production < script/delete_old_user_events.sql"
  command "tar cvfz /home/cyrille/backups/assets-`date +\\%Y-\\%m-\\%d`.tar.gz /var/rails/be_amazing/shared/assets > /home/cyrille/tar.log", :output => {:error => '/var/log/cron_bam.log', :standard => nil}
  runner "TaskUtils.check_inconsistent_tabs"
  runner "TaskUtils.change_homepage_featured_article"
end
every 1.day, :at => "4am"  do
  command "/var/rails/be_amazing/current/script/runs3sync"
  command "ruby script/delete_old_S3_files.rb"
  runner "TaskUtils.recompute_points"
end

every 1.hour do
  # command "pg_dump -U postgres -d be_amazing_production > /home/cyrille/backups/postgres-backup-`date +\\%H-00.sql`"
  # command "/var/rails/be_amazing/current/script/s3sync"
  runner "TaskUtils.generate_autocomplete_subcategories"
  runner "TaskUtils.count_users"
  runner "TaskUtils.update_counters"
  runner "TaskUtils.process_paid_xero_invoices"
  runner "TaskUtils.recompute_resident_experts"
end

every 5.minutes do
  runner "UserEmail.check_and_send_mass_emails"
end