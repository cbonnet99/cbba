require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!(
:access_key_id => '09M23471K1QC4FPBN9R2',
:secret_access_key => 'vMIWZ6w/0b8PAdQIj2nZMjJ9aijbgX1mdpWe/fRI'
)

bucket = AWS::S3::Bucket.find('backups.beamazing.co.nz')

begin
  DAYS_IN_SECONDS = 60*60*24
  puts "Deleting objects in bucket"

  bucket.objects.each do |object|
    puts "Inspecting #{object.key}"
    day, month, year = object.key.split("-").reverse
    created_on = Time.parse("#{year}-#{month}-#{day}")
    if Time.now-14*DAYS_IN_SECONDS > created_on
      object.delete
      puts "--- DELETED #{object.key}"
    end
    puts "-----------------------------------"
  end

  puts "Done deleting objects"

rescue SocketError
puts "Had socket error"
end
