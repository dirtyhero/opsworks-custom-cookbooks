template '/etc/td-agent/conf.d/billing.conf' do
  source 'td_agent_billing.conf.erb'
  owner 'td-agent'
  group 'td-agent'
  mode '0644'
end

service "td-agent" do
  action [ :enable, :restart ]
end