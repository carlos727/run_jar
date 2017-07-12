# Cookbook Name:: run_jar
# Recipe:: prepare
# Prepare node to run jar
# Copyright (c) 2017 The Authors, All Rights Reserved.

ruby_block 'Delete .jar Files' do
  block do
    Dir.foreach('C:\chef') do |jar|
      next unless jar.end_with? '.jar'
      File.delete "C:\\chef\\#{jar}"
    end
  end
end

file 'C:\Eva\installer.log' do
  action :delete
end
