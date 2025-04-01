object @request

attribute :id

node :link do |request|
  download_api_request_url(request)
end

child :certificate do
  extends 'foreman_x509/api/v2/certificates/base'
end

child :generation do
  extends 'foreman_x509/api/v2/generations/base'
end

