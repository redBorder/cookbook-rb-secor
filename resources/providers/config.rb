# Cookbook:: Secor
# Provider:: configure

include Secor::Helper

action :add do
  begin

    dnf_package 'rb-secor' do
      action :install
      flush_cache [:before]
    end

    s3_hostname = new_resource.s3_hostname
    s3_user = new_resource.s3_user
    s3_pass = new_resource.s3_pass
    s3_bucket = new_resource.s3_bucket
    zk_hosts = new_resource.zk_hosts
    kafka_hosts = new_resource.kafka_hosts
    s3_port = new_resource.s3_port
    manager_services = new_resource.manager_services
    s3_server = new_resource.s3_server

    service 'rb-secor' do
      supports start: true, enable: true
      action [:start, :enable]
    end

    service 'rb-secor-vault' do
      supports start: true, enable: true
      action [:start, :enable]
    end

    group 'secor' do
      action :create
    end

    execute 'create_secor_user' do
      command 'useradd -m -r -g secor secor'
      not_if 'id -u secor'
    end    

    directory "/var/secor" do
      owner "secor"
      group "secor"
      mode 0770
      action :create
    end
    
    directory "/mnt/secor_data" do
      owner "secor"
      group "secor"
      mode 0770
      recursive true
      action :create
    end
    
    execute 'create_logs_symlink' do
      command 'ln -s /var/log/secor /mnt/secor_data/logs'
      not_if 'test -L /mnt/secor_data/logs'
    end    
    
    directory "/tmp/secor_data" do
      owner "secor"
      group "secor"
      mode 0770
      action :create
    end
    
    directory "/mnt/secor_vault_data" do
      owner "secor"
      group "secor"
      mode 0770
      recursive true
      action :create
    end
    
    execute 'create_logs_symlink' do
      command 'ln -s /var/log/secor-vault /mnt/secor_vault_data/logs'
      not_if 'test -L /mnt/secor_vault_data/logs'
    end    
    
    directory "/tmp/secor_vault_data" do
      owner "secor"
      group "secor"
      mode 0770
      action :create
    end

    directory "/var/log/secor" do
      owner "secor"
      group "secor"
      mode 0770
      recursive true
      action :create
    end

    directory "/var/log/secor-vault" do
      owner "secor"
      group "secor"
      mode 0770
      recursive true
      action :create
    end

    template "/var/secor/secor.common.properties" do
      source "secor.common.properties.erb"
      cookbook 'secor'
      owner "secor"
      group "secor"
      mode 0644
      retries 2
      variables(:s3_hostname => s3_hostname, :s3_user => s3_user, :s3_pass => s3_pass, :s3_bucket => s3_bucket)
      notifies :restart, "service[rb-secor]", :delayed if manager_services["secor"]
    end

    template "/etc/sysconfig/secor" do
      source "mem_sysconfig.erb"
      cookbook 'secor'
      owner "secor"
      group "secor"
      mode 0644
      retries 2
      variables(:memory => node['redborder']['memory_services']['secor']['memory'])
      notifies :restart, "service[rb-secor]", :delayed if manager_services["secor"]
    end
    
    template "/etc/sysconfig/secor-vault" do
      source "mem_sysconfig.erb"
      cookbook 'secor'
      owner "secor"
      group "secor"
      mode 0644
      retries 2
      variables(:memory => node['redborder']['memory_services']['secor-vault']['memory'])
      notifies :restart, "service[rb-secor-vault]", :delayed if manager_services["secor-vault"]
    end

    template "/var/secor/log4j.prod.properties" do
        source "secor_log4j.prod.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        notifies :restart, "service[rb-secor]", :delayed if manager_services["secor"]
    end
    
    template "/var/secor/secor.prod.properties" do
        source "secor.prod.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        variables(:zk_hosts => zk_hosts, :kafka_hosts => kafka_hosts, :s3_bucket => s3_bucket)
        notifies :restart, "service[rb-secor]", :delayed if manager_services["secor"]
    end
    
    template "/var/secor/secor.prod.partition.properties" do
        source "secor.prod.partition.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        notifies :restart, "service[rb-secor]", :delayed if manager_services["secor"]
    end
    
    template "/var/secor/jets3t.properties" do
        source "jets3t.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        variables(:s3_bucket => s3_bucket, :s3_server => s3_server, :s3_port => s3_port)
        notifies :restart, "service[rb-secor]", :delayed if manager_services["secor"]
        notifies :restart, "service[rb-secor-vault]", :delayed if manager_services["secor-vault"]
    end
    
    template "/var/secor/secor-vault.common.properties" do
        source "secor-vault.common.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        variables(:s3_hostname => s3_hostname, :s3_user => s3_user, :s3_pass => s3_pass)
        notifies :restart, "service[rb-secor-vault]", :delayed if manager_services["secor-vault"]
    end
    
    template "/var/secor/log4j-vault.prod.properties" do
        source "secor-vault_log4j.prod.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        notifies :restart, "service[rb-secor-vault]", :delayed if manager_services["secor-vault"]
    end
    
    template "/var/secor/secor-vault.prod.properties" do
        source "secor-vault.prod.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        variables(:zk_hosts => zk_hosts, :kafka_hosts => kafka_hosts, :s3_bucket => s3_bucket)
        notifies :restart, "service[rb-secor-vault]", :delayed if manager_services["secor-vault"]
    end
    
    template "/var/secor/secor-vault.prod.partition.properties" do
        source "secor-vault.prod.partition.properties.erb"
        cookbook 'secor'
        owner "secor"
        group "secor"
        mode 0644
        retries 2
        notifies :restart, "service[rb-secor-vault]", :delayed if manager_services["secor-vault"]
    end
  
    Chef::Log.info('rbsecor has been configured correctly.')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service 'secor' do
      supports stop: true, disable: true
      action [:stop, :disable]
    end

    service 'secor-vault' do
      supports stop: true, disable: true
      action [:stop, :disable]
    end

    Chef::Log.info('rbsecor cookbook has been processed')
  rescue => e
    Chef::Log.error(e.message)
  end
end