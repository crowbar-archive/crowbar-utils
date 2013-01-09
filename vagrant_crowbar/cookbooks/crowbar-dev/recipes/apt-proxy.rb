
template "/etc/apt/apt.conf.d/00proxy" do
                source "apt-proxy.erb"
                variables ({
                :proxy_host => node.props.guest_http_proxy,
       		:proxy_ssl_host => node.props.guest_https_proxy
	})
end

