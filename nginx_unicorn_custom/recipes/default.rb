include_recipe 'nginx'
# setup Unicorn service per app
node[:deploy].each do |application, deploy|

  #deploy = node[:deploy][application]

  deploy.each do |key,value|
    Chef::Log.debug("deploy[:#{key}] = '#{value}'")
  end

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
      :application => application,
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
                :deploy => application  ### ここで代入している
    })
    notifies :restart, "service[nginx]"
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
