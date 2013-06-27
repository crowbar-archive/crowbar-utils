
proxy_settings "parent proxy 00" do
	http_proxy node.props.guest_https_proxy
	https_proxy node.props.guest_https_proxy
end
