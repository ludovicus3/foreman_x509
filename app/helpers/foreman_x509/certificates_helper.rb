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

      buttons << link_to(_('Activate'), activate_generation_path(generation), method: :put) if generation.status == 'inactive'
      buttons << link_to(_('Download Certificate'), certificate_certificate_generation_path(generation)) unless generation.status == 'pending'
      buttons << link_to(_('Upload Certificate'), edit_certificate_generation_path(generation)) if generation.status == 'pending'
      buttons << link_to(_('Download Request'), request_certificate_generation_path(generation)) if generation.status == 'pending'
      buttons << link_to(_('Download Key'), key_certificate_generation_path(generation)) unless generation.key.nil?
      buttons << link_to(_('Delete'), generation_path(generation), method: :delete, data: { confirm: _("Are you sure?") }) unless generation.active?

      action_buttons(buttons)
    end
  end
end