
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
                "win_domain_username" => node.props.win_domain_username,
                "win_domain_name" => node.props.win_domain_name,
                "win_domain_password" => node.props.win_domain_password,
                "win_domain_proxy" => node.props.win_domain_proxy
        })
end

service "cntlm" do
	supports :restart => true
	action :enable 
	subscribes :restart, resources("template[/etc/cntlm.conf]"), :immediately
end


http_proxy='http://127.0.0.1:5865'

template "/etc/apt/apt.conf.d/00proxy" do
                source "apt-proxy.erb"
                variables ({
                :proxy_host => http_proxy,
                :proxy_ssl_host => http_proxy
        })
end


execute "proxy on by default" do
        command " echo \"export http_proxy=#{http_proxy}\nexport https_proxy=#{http_proxy}\n\" >> /etc/profile"
        action :run
end

#template "/etc/apt/apt.conf.d/00proxy" do
#                source "apt-proxy.erb"
#                variables ({
#               :proxy_host => node.props.guest_http_proxy,
#       		:proxy_ssl_host => node.props.guest_https_proxy
#	})
#end

