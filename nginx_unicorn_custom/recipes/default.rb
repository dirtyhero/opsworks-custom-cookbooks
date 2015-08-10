include_recipe 'nginx'
# setup Unicorn service per app
node[:deploy].each do |application, deploy|
  Chef::Log.level = :debug
  Chef::Log.debug("-----application-----")
  Chef::Log.debug("#{application}")
  Chef::Log.debug("-----deploy-----")
  Chef::Log.debug("#{deploy}")

  #deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "#{deploy[:deploy_to]}/shared/config/unicorn.conf" do
    mode '0644'
    owner deploy[:user]
    group deploy[:group]
    source "unicorn.conf.erb"
    variables(
      :deploy => deploy,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    )
    notifies :run, "execute[restart Rails app #{application}]"

  end

  template "#{node[:nginx][:dir]}/sites-available/#{application}" do
    mode '0644'
    source "nginx_unicorn_web_app.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :deploy => deploy,
      :environment => OpsWorks::Escape.escape_double_quotes(deploy[:environment_variables])
    })
    if File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{application}")
      notifies :reload, "service[nginx]", :delayed
    end
  end

  # template "#{deploy[:deploy_to]}/shared/config/database.yml" do
  #   source "database.yml.erb"
  #   cookbook 'rails'
  #   mode "0660"
  #   group deploy[:group]
  #   owner deploy[:user]
  #   variables(:database => deploy[:database], :environment => deploy[:rails_env])

  #   notifies :run, "execute[restart Rails app #{application}]"

  #   only_if do
  #     deploy[:database][:host].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
  #   end
  # end

end
