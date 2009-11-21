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

set :cron_log, "/var/log/cron_bam.log"

every 1.week do
  rake "bam:count_published_items"
end

every 1.day, :at => "3am"  do
  runner "TaskUtils.rotate_feature_ranks"
  runner "TaskUtils.mark_down_old_users"
  runner "TaskUtils.send_reminder_on_expiring_memberships"
  command "find /home/cyrille/backups/postgres* -type f -mtime +14 | xargs rm -Rf"
  command "find /home/cyrille/backups/assets-* -type f -mtime +14 | xargs rm -Rf"
  runner "TaskUtils.rotate_user_positions_in_subcategories"
  runner "TaskUtils.rotate_user_positions_in_categories"
  runner "TaskUtils.suspend_full_members_when_membership_expired"
  command "pg_dump -U postgres -d be_amazing_production > /home/cyrille/backups/postgres-backup-`date +\\%Y-\\%m-\\%d`.sql"
  command "psql -U postgres be_amazing_production < script/delete_old_user_events.sql"
  command "tar cvfz /home/cyrille/backups/assets-`date +\\%Y-\\%m-\\%d`.tar.gz /var/rails/be_amazing/shared/assets > /home/cyrille/tar.log 2>&1"
end
every 1.day, :at => "4am"  do
  command "/var/rails/be_amazing/current/script/s3sync"
end

every 1.hour do
  # command "pg_dump -U postgres -d be_amazing_production > /home/cyrille/backups/postgres-backup-`date +\\%H-00.sql`"
  # command "/var/rails/be_amazing/current/script/s3sync"
  runner "TaskUtils.generate_autocomplete_subcategories"
  runner "TaskUtils.count_users"
  runner "TaskUtils.update_counters"
  runner "TaskUtils.process_paid_xero_invoices"
end

every 5.minutes do
  runner "UserEmail.check_and_send_mass_emails"
end