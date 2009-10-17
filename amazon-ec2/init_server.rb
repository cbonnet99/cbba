#!/usr/bin/env ruby

  require 'rubygems'
  require 'EC2'

  ACCESS_KEY_ID = ENV['AMAZON_ACCESS_KEY_ID']
  SECRET_ACCESS_KEY = ENV['AMAZON_SECRET_ACCESS_KEY']
  
  if ACCESS_KEY_ID.nil? || ACCESS_KEY_ID.empty?
    puts "Error : You must add the shell environment variables AMAZON_ACCESS_KEY_ID and AMAZON_SECRET_ACCESS_KEY before calling #{$0}!"
    exit
  end

  ec2 = EC2::Base.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)


  puts "Starting instance"
  response = ec2.run_instances(:image_id => "ami-c0f615a9", :key_name => "cyrille-keypair", :group_id => ["bam_security"] )
  
  
  instance_id = response.instancesSet.item[0].instanceId
  puts "Started instance #{instance_id}"
  puts "Associating IP address"
  ec2.associate_address(:instance_id => instance_id, :public_ip => "174.129.33.107")
  puts "Associated IP address to your instance"
  
  