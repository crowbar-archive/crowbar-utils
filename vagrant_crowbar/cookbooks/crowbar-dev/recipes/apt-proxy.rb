
proxy_settings "parent proxy 00" do
	http_proxy node.props.https_proxy
	https_proxy node.props.https_proxy
end
