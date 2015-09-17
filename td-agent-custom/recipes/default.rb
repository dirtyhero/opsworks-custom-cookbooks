#
# Cookbook Name:: td-agent-custom
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

  Chef::Log.level = :debug
  Chef::Log.debug("-----td-agent-custom default start-----")
  instance_id=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id |cut -f 1`.chomp
  Chef::Log.debug("#{instance_id}")
  Chef::Log.debug("-----td-agent-custom default end-----")

script "install td-agent" do
  interpreter "bash"
  cwd "/tmp"
  user "root"
  code <<-EOH
rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent
cat >/etc/yum.repos.d/td.repo <<'EOF';
[treasuredata]
name=TreasureData
baseurl=http://packages.treasuredata.com/2/redhat/\$releasever/\$basearch
gpgcheck=1
gpgkey=https://packages.treasuredata.com/GPG-KEY-td-agent
EOF
yum install -y td-agent
  EOH
  not_if "rpm -qa | grep td-agent"
end

node["td_agent"]["plugins"].each do |plugin|
  execute "install td-agent-gem #{plugin}" do
    cwd "/tmp"
    user "root"
    command "/usr/sbin/td-agent-gem install #{plugin}"
    not_if "/usr/sbin/td-agent-gem list|grep #{plugin}"
  end
end

directory '/etc/td-agent/conf.d' do
  owner 'td-agent'
  group 'td-agent'
  mode '0755'
  action :create
end

template '/etc/td-agent/td-agent.conf' do
  source 'td_agent.conf.erb'
  owner 'td-agent'
  group 'td-agent'
  mode '0644'
end

service "td-agent" do
  action [ :enable, :restart ]
end
