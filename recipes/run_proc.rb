# Cookbook Name:: run_jar
# Recipe:: run_proc
# Run jar process
# Copyright (c) 2017 The Authors, All Rights Reserved.

#
# Variables
#
mail_to = node["mail"]["to"]
restart = node["tomcat"]["restart"]
run = false
message_jar = "#{$jar_name}.jar execution returned "

#
# Main process
#
ruby_block 'Wait Tomcat' do
  block do
    Tomcat.wait_start
  end
  action :nothing
end

windows_service 'Tomcat7' do
  action :nothing
  timeout 180
  notifies :run, 'ruby_block[Wait Tomcat]', :immediately
  only_if { run && restart }
end

file "C:\\chef\\#{$jar_name}.jar" do
  action :nothing
  notifies :restart, 'windows_service[Tomcat7]', :immediately
end

ruby_block 'Run jar' do
  block do
    jar = powershell_out!("& '#{Java.get_exe}' -jar C:\\chef\\#{$jar_name}.jar")

    Chef::Log.info(jar.stdout.chomp)
    Chef::Log.info(jar.stderr.chomp)

    if File.exist? 'C:\Eva\installer.log'
    # if jar.stdout[/1/]
      run = true
      message_jar << "1"
    else
      run = false
      message_jar << "0"
    end

    Chef::Log.info(message_jar)
  end
  action :nothing
  notifies :delete, "file[C:\\chef\\#{$jar_name}.jar]", :immediately
end

log "jar downloaded from #{$jar_source}" do
  action :nothing
  notifies :run, 'ruby_block[Run jar]', :immediately
end

remote_file "C:\\chef\\#{$jar_name}.jar" do
  source $jar_source
  notifies :write, "log[jar downloaded from #{$jar_source}]", :immediately
end

ruby_block 'Send Email jar' do
  block do
    f = Tools.fetch 'http://localhost:8080/Eva/apilocalidad/version'
    message_jar << " in #{f["codLocalidad"]} #{f["descripLocalidad"]} !"
    Chef::Log.info(message_jar)
    Tools.simple_email mail_to, :message => message_jar, :subject => "Chef Run jar on Node #{$node_name}"
  end
end
