object @generation

extends 'foreman_x509/api/v2/generations/base'

child :owner do
  extends 'foreman_x509/api/v2/certificates/base'
end