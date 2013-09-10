
if node.props.proxy_on =~ /true/i then

  http_proxy = node.props.http_proxy
  https_proxy = node.props.https_proxy
  ENV['HTTP_PROXY'] = node['http_proxy']
  node.default["gem_options"] = "--http-proxy #{http_proxy}"

# run in compilation phase
  if http_proxy
    Chef::Config[:http_proxy] = http_proxy
    Chef::Log.info "Setting Chef http_proxy to '#{Chef::Config[:http_proxy]}'."
  end

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
#  execute "proxy on by default ~/.bashrc" do

  execute "proxy on by default /etc/profile" do
    command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{https_proxy}\n\" >> /etc/profile"
    action :run
    not_if "grep http_proxy /etc/profile"
  end

  execute "proxy on by default /etc/environment" do
    command " echo \"HTTP_PROXY=#{http_proxy}\nHTTPS_PROXY=#{https_proxy}\n\" >> /etc/environment"
    action :run
    not_if "grep http_proxy /etc/environment"
  end
end
