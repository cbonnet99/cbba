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

every 1.week do
  rake "bam:count_published_items"
end

every 1.day, :at => "3am"  do
  runner "TaskUtils.mark_down_old_users"
  runner "TaskUtils.send_reminder_on_expiring_memberships"
  command "find /home/cftuser/backups/postgres* -type f -mtime +14 | xargs rm -Rf"
  command "find /home/cftuser/backups/assets-* -type f -mtime +14 | xargs rm -Rf"
  runner "TaskUtils.rotate_user_positions_in_subcategories"
  runner "TaskUtils.rotate_user_positions_in_categories"
  runner "TaskUtils.suspend_full_members_when_membership_expired"
  command "pg_dump -U postgres -d be_amazing_production > /home/cftuser/backups/postgres-backup-`date +\\%Y-\\%m-\\%d`.sql"
  command "/usr/local/cft/deploy/rails/script/delete-old-sessions"
  command "tar cvfz /home/cftuser/backups/assets-`date +\\%Y-\\%m-\\%d`.tar.gz /usr/local/cft/deploy/capistrano/shared/assets > /home/cftuser/tar.log 2>&1"
end
# every 1.day, :at => "4am"  do
#   command "/home/cftuser/s3sync/s3sync.rb --debug -r /home/cftuser/backups/ backups.beamazing.co.nz:/"
# end

every 1.hour do
  command "pg_dump -U postgres -d be_amazing_production > /home/cftuser/backups/postgres-backup-`date +\\%H-00.sql`"
  command "/usr/local/cft/deploy/rails/script/s3fs"
  runner "TaskUtils.generate_autocomplete_subcategories"
  runner "TaskUtils.count_users"
  runner "TaskUtils.update_counters"
  runner "TaskUtils.process_paid_xero_invoices"
end

every 5.minutes do
  runner "UserEmail.check_and_send_mass_emails"
end