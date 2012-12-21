if sidekiq_instance?

  # for now
  worker_count = 1

  node[:applications].each do |app, data|
    template "/etc/monit.d/sidekiq_#{app}.monitrc" do
      owner 'root'
      group 'root'
      mode 0644
      source "monitrc.conf.erb"
      variables({
        :num_workers => worker_count,
        :app_name => app,
        :rails_env => node[:environment][:framework_env],
        :user => node[:owner_name]
      })
    end

    template "/engineyard/bin/sidekiq" do
      owner 'root'
      group 'root'
      mode 0755
      source "sidekiq.erb"
    end
    template "/data/#{app}/shared/config/sidekiq.rb" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source "sidekiq.rb.erb"
      variables({
        namespace: "'#{app}:#{node[:environment][:framework_env]}'",
        url: "'redis://#{node['db_host']}:6379'"
      })
    end
    worker_count.times do |count|
      template "/data/#{app}/shared/config/sidekiq_#{count}.yml" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        source "sidekiq.yml.erb"
        variables({
          :require => "/data/#{app}/current",
          :verbose => false,
          :concurrency => 30,
          :queues => { 'default' => 25 }
        })
      end
    end

  end
end
