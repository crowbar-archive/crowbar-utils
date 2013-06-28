
define :proxy_settings, :http_proxy => "" , :https_proxy => "" do

  if node.props.proxy_on then

    http_proxy = params[:http_proxy]
    https_proxy = params[:https_proxy]

    case node[:platform]
    when "ubuntu"
      template "/etc/apt/apt.conf.d/00proxy" do
          source "apt-proxy.erb"
          variables ({
          :proxy_host => http_proxy,
          :proxy_ssl_host => https_proxy
        })
      end

    when "suse"
      template "/etc/sysconfig/proxy" do
        source "suse_proxy_settings.erb"
        variables ({
          :proxy_enabled => "yes",
          :http_proxy => http_proxy,
          :https_proxy => https_proxy
        })
      end
    end

    execute "proxy on by default root ~/.bashrc" do
      command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /root/.bashrc"
      action :run
    end

    execute "proxy on by default ~/.bashrc" do
      command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /home/#{node.props.guest_username}/.bashrc"
      action :run
    end

    execute "proxy on by default /etc/profile" do
      command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /etc/profile"
      action :run
    end
  end
end
