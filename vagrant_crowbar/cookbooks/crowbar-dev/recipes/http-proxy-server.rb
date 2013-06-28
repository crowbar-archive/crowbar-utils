proxy_name = 'http-proxy'

case node[:platform]
when 'ubuntu'
  proxy_name = 'polipo'
when 'suse'
  proxy_name = 'tinyproxy'
  execute 'SuSE takes forever with their filesharin pkgs' do
    command 'echo "export ZYPP_ARIA2C=0" >> ~/.bashrc; echo "export ZYPP_ARIA2C=0" >> ~/.bash_profile'
    not_if "grep 'ZYPP_ARIA2C=0' ~/.bashrc"
  end
end
 

package "#{proxy_name}" do
  action :install
end


case node[:platform]
when "ubuntu"

  service "#{proxy_name}" do
    supports :restart => true, :reload => true
    action :enable
  end


  template "/etc/polipo/config.work" do
    source "polipo.erb"
    mode 00644
    variables ({
        :proxyAddress => "::0",
        :proxyPort => "8123",
        :allowedClients => "127.0.0.0/8, 192.168.0.0/16, ::1/128",
        :cacheIsShared => "true",
        :chunkHighMark => "50331648",
        :objectHighMark => "16384",
        :tunnelAllowedPorts => "22, 80, 109-110, 143, 443, 873, 993, 995, 1024-65535",
        :diskCacheRoot => "/var/cache/polipo",
        :parentProxy => guest_parent_proxy
          })
  end

  template "/etc/polipo/config.home" do
    source "polipo.erb"
    mode 00644
    variables ({
        :proxyAddress => "::0",
        :proxyPort => "8123",
        :allowedClients => "127.0.0.0/8, 192.168.0.0/16, ::1/128",
        :cacheIsShared => "true",
        :chunkHighMark => "50331648",
        :objectHighMark => "16384",
        :tunnelAllowedPorts => "22, 80, 109-110, 143, 443, 873, 993, 995, 1024-65535",
        :diskCacheRoot => "/var/cache/polipo"
          })
  end

  cookbook_file "/home/#{node.props.guest_username}/proxy" do
    source "proxy"
    mode 00755
  end

  execute "switch polipo to #{node.props.proxy_mode}" do
    command "/home/#{node.props.guest_username}/proxy #{node.props.proxy_mode}"
    action :run
          #notifies :run, resources(:execute => "apt-get update"), :immediately
    notifies :restart, "service[polipo]", :immediately
          #notifies :create, resources(:cookbook_file => "/home/#{node.props.guest_username}/proxy"), :immediately
  end
end

