cookbook_file "/tmp/cntlm_0.92.3_amd64.deb" do
	source "cntlm_0.92.3_amd64.deb"
end

package "cntlm" do
	source "/tmp/cntlm_0.92.3_amd64.deb"
	provider Chef::Provider::Package::Dpkg
	action :install
end


# switch the apt proxy host to this until polipo is installed

template "/etc/cntlm.conf" do
        source "cntlm.conf.erb"
        mode 0640
        variables ({
                "cntlm_domain_username" => node.props.cntlm_domain_username,
                "cntlm_domain_name" => node.props.cntlm_domain_name,
                "cntlm_domain_password" => node.props.cntlm_domain_password,
                "cntlm_domain_proxy" => node.props.cntlm_domain_proxy
        })
end

service "cntlm" do
	supports :restart => true
	action :enable 
	subscribes :restart, resources("template[/etc/cntlm.conf]"), :immediately
end

proxy_settings "cntlm on" do
	http_proxy "http://127.0.0.1:5865"
	https_proxy "http://127.0.0.1:5865"
end

#template "/etc/apt/apt.conf.d/00proxy" do
#                source "apt-proxy.erb"
#                variables ({
#               :proxy_host => node.props.guest_http_proxy,
#       		:proxy_ssl_host => node.props.guest_https_proxy
#	})
#end

