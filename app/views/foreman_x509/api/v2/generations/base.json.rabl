object @generation

attribute :id

node(:certificate_link) do |generation|
  certificate_api_certificate_generation_url(generation.owner, generation) if generation.certificate?
end

node(:key_link) do |generation|
  key_api_certificate_generation_url(generation.owner, generation) if generation.key?
end