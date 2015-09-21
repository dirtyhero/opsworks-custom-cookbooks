template '/etc/td-agent/conf.d/dynamodb.conf' do
  source 'td_agent_dynamodb.conf.erb'
  owner 'td-agent'
  group 'td-agent'
  mode '0644'
end

service "td-agent" do
  action [ :enable, :restart ]
end