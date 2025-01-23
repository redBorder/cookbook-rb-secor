# Cookbook:: secor
# Recipe:: default
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

secor_config 'add' do
  user node['redborder']['secor']['user']
  group node['redborder']['secor']['group']
  kafka_hosts node['redborder']['secor']['kafka_hosts']
  zk_hosts node['redborder']['secor']['zk_hosts']
  manager_services node['redborder']['secor']['manager_services']
  s3_server node['redborder']['secor']['s3_hostname']
  s3_user node['redborder']['secor']['s3_user']
  s3_pass node['redborder']['secor']['s3_pass']
  s3_bucket node['redborder']['secor']['s3_bucket']
  s3_port node['redborder']['secor']['s3_port']
  action :add
end
