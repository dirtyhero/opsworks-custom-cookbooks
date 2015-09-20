template '/etc/td-agent/conf.d/elb.conf' do
  source 'td_agent_elb.conf.erb'
  owner 'td-agent'
  group 'td-agent'
  mode '0644'
end