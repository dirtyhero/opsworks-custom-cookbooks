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

  template "#{deploy[:deploy_to]}/current/config/redis.yml" do
    source "redis.yml.erb"
    mode '0644'
    group deploy[:group]
    owner deploy[:user]
    # only generate a file if there is Redis configuration
    only_if do
      deploy[:redis][:host].present? && File.directory?("#{deploy[:deploy_to]}/current/config/")
    end
    notifies :run, "execute[restart Rails app #{application}]"
  end

end
