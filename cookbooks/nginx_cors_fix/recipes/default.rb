#
# Cookbook Name:: nginx_cors_fix
# Recipe:: default
#

if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app, data|

    template "/tmp/location.block" do
      source 'location.block'
    end

    execute "add header to conf" do
      command "sed -i '/error_log \/var\/log\/engineyard\/nginx\/#{app[:name]}.error.log notice;/r /tmp/location.block' /etc/nginx/servers/#{app[:name]}.conf"
      not_if "grep -q Access-Control-Allow-Origin /etc/nginx/servers/#{app[:name]}.conf"
    end
    execute "add header to ssl conf" do
      command "sed -i '/error_log \/var\/log\/engineyard\/nginx\/#{app[:name]}.error.log notice;/r /tmp/location.block' /etc/nginx/servers/#{app[:name]}.ssl.conf"
      not_if "grep -q Access-Control-Allow-Origin /etc/nginx/servers/#{app[:name]}.ssl.conf"
    end

  end
end
