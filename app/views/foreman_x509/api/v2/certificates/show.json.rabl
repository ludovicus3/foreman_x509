object @certificate

extends 'foreman_x509/api/v2/certificates/base'

child :issuer do
  extends 'foreman_x509/api/v2/issuers/base'
end