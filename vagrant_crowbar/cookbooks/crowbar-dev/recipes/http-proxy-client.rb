
if node.props.proxy_on =~ /true/i then

  http_proxy = node.props.http_proxy
  https_proxy = node.props.https_proxy

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

#  execute "proxy on by default root ~/.bashrc" do
#    command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /root/.bashrc"
#    action :run
#  end

#  execute "proxy on by default ~/.bashrc" do
#    command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /home/#{node.props.guest_username}/.bashrc"
#    action :run
#  end

  execute "proxy on by default /etc/profile" do
    command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /etc/profile"
    action :run
    not_if "grep http_proxy /etc/profile"
  end

  execute "proxy on by default /etc/environment" do
    command " echo \"HTTP_PROXY=#{http_proxy}\nHTTPS_PROXY=#{https_proxy}\n\" >> /etc/environment"
    action :run
    not_if "grep HTTP_PROXY /etc/environment"
  end
end
if node.props.proxy_on =~ /false/i then

execute "proxy off by command /etc/profile" do
   command " sed -i\".bak\" '/http_proxy/d' /etc/profile"
   action :run
   end
execute "proxy off by command /etc/profile" do
   command " sed -i\".bak\" '/https_proxy/d' /etc/profile"
   action :run
   end
   
execute "proxy off by command /etc/environment" do
   command "sed -i\".bak\" '/HTTP_PROXY/d' /etc/environment"
   action :run
   end
execute "proxy off by command /etc/environment" do 
   command "sed -i\".bak\" '/HTTPS_PROXY/d' /etc/environment"
   action :run
   end
case node[:platform]
   when "ubuntu"
     execute "remove 00proxy" do 
     command "sed -i\".bak\" '/HTTP_PROXY/d' /etc/apt/apt.conf.d/00proxy"
     action :run
     end
     execute "remove 00proxy" do 
     command "sed -i\".bak\" '/HTTPS_PROXY/d' /etc/apt/apt.conf.d/00proxy"
     action :run
     end
    end  
end
