module ForemanX509
  module CertificatesHelper
    def certificate_details
      if @certificate.certificate.present?
        @certificate.certificate.to_text
      else
        @certificate.subject.to_s(OpenSSL::X509::Name::MULTILINE)
      end
    end

    def issuer_link(certificate)
      return if certificate.issuer.nil?
      link_to certificate.issuer.name, issuer_path(certificate.issuer)
    end

    def certificate_download_links
      links = []

      links << link_to(_('Download Certificate'), certificate_certificate_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format certificate')) unless @certificate.certificate.nil?

      links << link_to(_('Sign Request'), request_path(@certificate.request),
                       class: 'btn btn-default',
                       title: _('Upload the signed certificate')) unless @certificate.request.nil?

      links << link_to(_('Download Key'), key_certificate_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format private key')) unless @certificate.key.nil?

      links
    end

    def generation_actions(generation)
      buttons = []

      params = [generation.owner, generation]

      buttons << link_to(_('Activate'), activate_certificate_generation_path(*params), method: :post) if generation.status == 'inactive'
      buttons << link_to(_('Download Certificate'), certificate_certificate_generation_path(*params)) unless generation.status == 'pending'
      buttons << link_to(_('Upload Certificate'), request_path(generation.request)) if generation.status == 'pending'
      buttons << link_to(_('Download Request'), download_api_request_path(generation.request)) if generation.status == 'pending'
      buttons << link_to(_('Download Key'), key_certificate_generation_path(*params)) unless generation.key.nil?
      buttons << link_to(_('Delete'), certificate_generation_path(*params), method: :delete, data: { confirm: _("Are you sure?") }) unless generation.active?

      action_buttons(buttons)
    end
  end
end