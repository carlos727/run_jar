# Cookbook Name:: run_jar
# Recipe:: default
# Run jar from Powershell
# Copyright (c) 2016 The Authors, All Rights Reserved.

#
# Variables
#
$node_name = Chef.run_context.node.name.to_s

if $node_name.start_with?('B') || $node_name.start_with?('RD')
   $jar_name, $jar_source = node["jar-bbi"]["name"], node["jar-bbi"]["url"]
elsif $node_name.start_with?('3') || $node_name.start_with?('9')
  $jar_name, $jar_source = node["jar-merc-buc"]["name"], node["jar-merc-buc"]["url"]
else
  $jar_name, $jar_source = node["jar-merc-bog"]["name"], node["jar-merc-bog"]["url"]
end

#
# Main process
#
include_recipe 'run_jar::prepare'

include_recipe 'run_jar::run_proc'
