node[:deploy].each do |application, deploy|

  Chef::Log.level = :debug
  Chef::Log.debug("-----td-agent-custom application-----"
  Chef::Log.debug("-----application-----"
  Chef::Log.debug("#{application}")
  Chef::Log.debug("-----deploy-----"
  Chef::Log.debug("#{deploy}")

  service "td-agent" do
    action :nothing
  end
end