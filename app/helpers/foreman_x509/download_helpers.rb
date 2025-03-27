module ForemanX509
  module DownloadHelpers
    def certificate_download_links
      links = []

      links << link_to(_('Download Certificate'), certificate_certificate_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format certificate')) unless @certificate.certificate.nil?

      links << link_to(_('Download Request'), certificate_signing_request_path(@certificate),
                       class: 'btn btn-default',
                       title: _('Download the PEM format certificate signing request')) unless @certificate.request.nil?

      links << link_to(_('Run'), certificate_key_path(@certificate),
                       class: 'btn btn-primary',
                       title: _('Download the PEM format private key')) unless @certificate.key.nil?

      links
    end
  end
end