#
# Cookbook Name:: whenever
# Recipe:: default
#

ey_cloud_report "whenever" do
  message "starting whenever recipe"
end

# Set your application name here
appname = "wowzDashboard"

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

  if node[:environment][:framework_env] == 'production'
    local_user = node[:users].first
    execute "whenever" do
      cwd "/data/#{appname}/current"
      user local_user[:username]
      command "bundle exec whenever --update-crontab '#{appname}_#{node[:environment][:framework_env]}'"
      action :run
    end

    ey_cloud_report "whenever" do
      message "whenever recipe complete"
    end
  end
  # be sure to replace "app_name" with the name of your application.
end
