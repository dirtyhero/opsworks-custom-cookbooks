include_recipe 'htpasswd'

htpasswd "/etc/nginx/.htpasswd" do
  user node[:nginx_basic_auth][:user]
  password node[:nginx_basic_auth][:password]
end
