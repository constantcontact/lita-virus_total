module Lita
  module Handlers
    class VirusTotal < Handler
      require 'uirusu'
      require 'uri'

      config :api_key, required: true

      route(/^vt (.*)/i,
            :virus_total,
            command: false,
            help: { t('help.vt_key') => t('help.vt_value') }
           )

      route(/^virus total (.*)/i,
            :virus_total,
            command: false,
            help: { t('help.virus_total_key') => t('help.vt_value') }
           )

      def virus_total(response)
        match = response.match_data[1]

        message = case
                  when url?(match)
                    url_report match
                  when match =~ /\S+\.\S+/
                    url_report(match)
                  else
                    file_report match
                  end

        response.reply message
      end

      private

      def report(result)
        data = []
        translations = I18n.backend.send(:translations)
        require 'pp'
        pp translations
        data << I18n.translate('lita.handlers.virus-total.report.header', result)
        binding.pry
        #data << t("report.header", result)
        if result['positives'] > 0
          positives = result['scans'].map { |k, v| k if v['detected'] }.compact
          data << "Positive scans: #{positives.inspect}"
        end
        #data << t('report.link', link: result['permalink'])
        data << I18n.translate('lita.handlers.virus_total.report.link', link: result['permalink'])

        data.join "\n"
      end

      def url?(url)
        uri = URI.parse url
        uri.is_a? URI::HTTP
      rescue URI::InvalidURIError
        false
      end

      def api_key
        Lita.config.handlers.virus_total.api_key
      end

      def file_report(hash)
        result = Uirusu::VTFile.query_report(api_key, hash)

        report result
      end

      def url_report(url)
        result = Uirusu::VTUrl.query_report(api_key, url)
        report result
      end

      Lita.register_handler(self)
    end
  end
end
