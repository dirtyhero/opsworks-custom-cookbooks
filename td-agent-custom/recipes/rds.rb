template '/etc/td-agent/conf.d/rds.conf' do
  source 'td_agent_rds.conf.erb'
  owner 'td-agent'
  group 'td-agent'
  mode '0644'
end

service "td-agent" do
  action [ :enable, :restart ]
end