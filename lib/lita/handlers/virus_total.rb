module Lita
  module Handlers
    class VirusTotal < Handler
      require 'uirusu'
      require 'uri'

      config :api_key, required: true

      route(/^vt (.*)/i,
            :virus_total,
            command: false,
            help: { 'vt PATTERN' => 'Checks virus total for results of PATTERN' }
           )

      route(/^virus total (.*)/i,
            :virus_total,
            command: false,
            help: { 'virus total PATTERN' => 'Checks virus total for results of PATTERN' }
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

      def header(key, result)
        positive_results = "#{result['positives']}/#{result['total']} positive results"
        "#{key} had #{positive_results} on #{result['scan_date']}"
      end

      def report(key, result)
        data = []
        data << header(key, result)
        if result['positives'] > 0
          positives = result['scans'].map { |k, v| k if v['detected'] }.compact
          data << "Positive scans: #{positives.inspect}"
        end
        data << "Full report: #{result['permalink']}"

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

        report hash, result
      end

      def url_report(url)
        result = Uirusu::VTUrl.query_report(api_key, url)
        report url, result
      end

      Lita.register_handler(self)
    end
  end
end
