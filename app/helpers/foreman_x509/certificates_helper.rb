module ForemanX509
  module CertificatesHelper
    def certificate_details
      if @certificate.certificate.present?
        @certificate.certificate.to_text
      else
        @certificate.request.to_pem
      end
    end

    def certificate_download_links
      links = []

      links << link_to(_('Download Certificate'), certificate_certificate_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format certificate')) unless @certificate.certificate.nil?

      links << link_to(_('Download Request'), signing_request_certificate_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format certificate signing request')) unless @certificate.request.nil?

      links << link_to(_('Download Key'), key_certificate_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format private key')) unless @certificate.key.nil?

      links
    end

    def generation_actions(generation)
      buttons = []

      buttons << display_link_if_authorized(hash_for_activate_generation_path(id: generation.id)).merge(engine: foreman_x509, auth_object: generation, authorizer: authorizer) if generation.status == 'inactive'
      buttons << display_link_if_authorized(hash_for_certificate_generation_path(id: generation.id)).merge(engine: foreman_x509, auth_object: generation, authorizer: authorizer) unless generation.certificate.nil?
      buttons << display_link_if_authorized(hash_for_signing_request_generation_path(id: generation.id)).merge(engine: foreman_x509, auth_object: generation, authorizer: authorizer) unless generation.request.nil?
      buttons << display_link_if_authorized(hash_for_key_generation_path(id: generation.id)).merge(engine: foreman_x509, auth_object: generation, authorizer: authorizer) unless generation.key.nil?
      buttons << display_delete_if_authorized(hash_for_generation_path(id: generation.id).merge(engine: foreman_x509, auth_object: generation, authorizer: authorizer), data: { confirm: _("Delete certificate generation, %s?") % generation.id }) unless generation.active?

      action_buttons(buttons)
    end
  end
end