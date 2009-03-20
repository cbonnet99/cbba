desc "Send mass email"
task :send_mass_email => :environment do
  mailing = MassEmail.find(ENV["MASS_EMAIL_ID"])
  mailing.deliver
end
