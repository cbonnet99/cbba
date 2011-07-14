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

env :PATH, '/opt/ruby-enterprise-1.8.7-2011.03/bin/:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/usr/local/rvm/bin:/home/ec2-user/bin'

every 1.month, :at => "beginning of the month at 3am" do
  command "psql -U postgres be_amazing_production < script/reset_monthly_view_counts.sql"  
end

every 2.weeks do
  runner "TaskUtils.generate_autocomplete_subcategories"
end

every :sunday, :at => '12pm'  do
  rake "bam:count_published_items"
  runner "TaskUtils.send_weekly_admin_stats"
end

every 1.day, :at => "1am"  do
  runner "TaskUtils.delete_old_unconfirmed_users"
  runner "TaskUtils.notify_unpublished_users"
end

every 1.day, :at => "2am"  do
  runner "TaskUtils.rotate_users"
  runner "TaskUtils.email_admins_about_to_be_deleted"
  runner "TaskUtils.email_users_will_be_deleted"
end

every 1.day, :at => "3am"  do
  runner "TaskUtils.check_feature_expiration"
  runner "TaskUtils.check_expired_offers"
  runner "TaskUtils.charge_expired_features"
end

every 1.day, :at => "4am"  do
  runner "TaskUtils.change_homepage_featured_article"
  runner "TaskUtils.change_homepage_featured_quote"
end

every 1.day, :at => "5am"  do
  runner "TaskUtils.recompute_resident_experts"
end

every 1.day, :at => "6am"  do
  runner "TaskUtils.send_offers_reminder"
  runner "TaskUtils.check_pending_payments"
end

every 1.day, :at => "7am"  do
  runner "TaskUtils.change_homepage_featured_resident_experts"
  runner "TaskUtils.delete_old_user_events(6.months.ago)"
end

every 1.day, :at => "3am"  do
  command "find ~/backups/postgres* -type f -mtime +14 | xargs rm -Rf"
  command "find ~/backups/assets-* -type f -mtime +14 | xargs rm -Rf"
  # runner "TaskUtils.rotate_user_positions_in_subcategories"
  # runner "TaskUtils.rotate_user_positions_in_categories"
  command "cp --preserve=timestamps /etc/httpd/conf/httpd.conf ~/backups"
  command "cp --preserve=timestamps /usr/local/nginx/conf/nginx.conf ~/backups"
  command "cp --preserve=timestamps /usr/local/nginx/conf/beamazing.co.nz.pem ~/backups"
  command "cp --preserve=timestamps /usr/local/nginx/conf/www-server.key ~/backups"
  command "cp --preserve=timestamps /etc/varnish/default.vcl /~/backups"
  command "pg_dump -U postgres be_amazing_production | gzip > ~/backups/bam-backup-`date +\\%Y-\\%m-\\%d`.sql.gz", :output => {:error => '/var/log/cron_bam.log'}
  command "psql -U postgres be_amazing_production < script/delete_old_user_events.sql"
  command "tar cvfz ~/backups/assets-`date +\\%Y-\\%m-\\%d`.tar.gz /var/rails/be_amazing/shared/assets > ~/tar.log", :output => {:error => '/var/log/cron_bam.log', :standard => nil}
end
every 1.day, :at => "4am"  do
  command "/var/rails/be_amazing/current/script/runs3sync"
  command "cd /var/rails/be_amazing/current/ && ruby script/delete_old_S3_files.rb"
end

every 1.hour do
  # command "pg_dump -U postgres -d be_amazing_production > ~/backups/postgres-backup-`date +\\%H-00.sql`"
  # command "/var/rails/be_amazing/current/script/s3sync"
  runner "TaskUtils.count_users"
  runner "TaskUtils.update_counters"
  runner "TaskUtils.process_paid_xero_invoices"
end

every 10.minutes do
  runner "TaskUtils.check_inconsistent_tabs"  
end

every 5.minutes do
  runner "UserEmail.check_and_send_mass_emails"
end