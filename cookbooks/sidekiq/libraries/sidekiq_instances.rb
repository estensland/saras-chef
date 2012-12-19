class Chef
  class Recipe
    # Does this instance run sidekiq?
    def sidekiq_instance?
      case node[:environment][:framework_env].to_s
      when 'staging'
        ['solo', 'app_master'].include?(node[:instance_role])
      else
        ['solo','util','eylocal'].include?(node[:instance_role]) && node[:name] =~ /^sidekiq/
      end
    end

  end
end
