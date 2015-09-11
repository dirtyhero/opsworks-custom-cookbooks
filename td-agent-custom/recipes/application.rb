node[:deploy].each do |application, deploy|

  Chef::Log.level = :debug
  Chef::Log.debug("-----td-agent-custom application-----")
  Chef::Log.debug("-----application-----")
  Chef::Log.debug("#{application}")
  Chef::Log.debug("-----deploy-----")
  Chef::Log.debug("#{deploy}")

  service "td-agent" do
    action :nothing
  end

  template "/etc/td-agent/conf.d/#{application}.conf" do
    mode '0644'
    source "td_agent_application.conf.erb"
    owner 'td-agent'
    group 'td-agent'
    mode 0644
    variables({
      :deploy => deploy,
      :application => application,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    })
    if File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{application}")
      notifies :reload, "service[td-agent]", :delayed
    end
  end

end