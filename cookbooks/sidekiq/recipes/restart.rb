if sidekiq_instance?

  execute "ensure-sidekiq-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  node[:applications].each do |app, data|
    execute "restart-sidekiq" do
      command %Q{
        echo "sleep 20 && monit -g #{app}_sidekiq restart all" | at now
      }
    end
  end

end
