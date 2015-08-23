node[:deploy].each do |application, deploy|

  Chef::Log.level = :debug
  Chef::Log.debug("-----application-----")
  Chef::Log.debug("#{application}")
  Chef::Log.debug("-----deploy-----")
  Chef::Log.debug("#{deploy}")

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end
  file "#{deploy[:deploy_to]}/current/config/redis.yml" do
    mode '0644'
    group deploy[:group]
    owner deploy[:user]
    # only generate a file if there is Redis configuration
    only_if do
      File.directory?("#{deploy[:deploy_to]}/current/config/")
    end
    notifies :run, "execute[restart Rails app #{application}]"
  end

end
