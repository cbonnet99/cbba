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

every 1.day, :at => "3am"  do
  runner "TaskUtils.mark_down_old_users"
  runner "TaskUtils.send_reminder_on_expiring_memberships"
  command "find /var/backups/postgres* -type f -mtime +14 | xargs rm -Rf"
  command "find /var/backups/assets-* -type f -mtime +14 | xargs rm -Rf"
  runner "TaskUtils.rotate_user_positions_in_subcategories"
  runner "TaskUtils.rotate_user_positions_in_categories"
  runner "TaskUtils.suspend_full_members_when_membership_expired"
  command "tar cvfz /usr/local/cft/deploy/capistrano/shared/assets /var/backups/assets-`date +'%Y-%m-%d'`"
  command "sudo -u postgres pg_dump -d be_amazing_production > /var/lib/postgresql/postgres-backup-`date +'%Y-%m-%d'`.sql"
  command "cp /var/lib/postgresql/postgres-backup-`date +'%Y-%m-%d'`.sql /var/backups"
  command "rm -f /var/lib/postgresql/postgres-backup-`date +'%Y-%m-%d'`.sql"
  command "/home/cftuser/s3sync/s3sync.rb -r /var/backups/ backups.beamazing.co.nz:/"
end

every 1.hour do
  runner "TaskUtils.count_users"
  runner "TaskUtils.update_counters"
  runner "TaskUtils.process_paid_xero_invoices"
end
