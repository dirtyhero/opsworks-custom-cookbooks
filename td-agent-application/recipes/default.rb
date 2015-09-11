node[:deploy].each do |application, deploy|

  Chef::Log.debug("-----application-----"
  Chef::Log.debug("#{application}")
  Chef::Log.debug("-----deploy-----"
  Chef::Log.debug("#{deploy}")

  service "td-agent" do
    action :nothing
  end

  # template "/etc/td-agent/conf.d/unicorn.conf" do
  #   mode '0644'
  #   owner deploy[:user]
  #   group deploy[:group]
  #   source "unicorn.conf.erb"
  #   variables(
  #     :deploy => deploy,
  #     :application => application,
  #     :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
  #   )
  #   notifies :reload, 'service[td-agent]'
  # end

end