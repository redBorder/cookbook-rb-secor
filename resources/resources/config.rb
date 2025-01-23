unified_mode true
# Cookbook:: rsyslog
# Resource:: configure

actions :add, :remove
default_action :add

attribute :user, kind_of: String, default: 'root'
attribute :group, kind_of: String, default: 'root'
attribute :kafka_hosts, kind_of: Array
attribute :s3_server, kind_of: String, default: 's3.service'
attribute :s3_hostname, kind_of: String, default: 's3.service'
attribute :s3_user, kind_of: String, default: 'redborder'
attribute :s3_pass, kind_of: String, default: 'redborder'
attribute :s3_port, kind_of: Integer, default: 9000
attribute :s3_bucket, kind_of: String, default: 'bucket'
attribute :manager_services, kind_of: Hash
attribute :zk_hosts, kind_of: String
