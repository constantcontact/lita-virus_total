module Lita
  module Handlers
    class VirusTotal < Handler
      require 'uirusu'

      config :api_key, required: true

      route(/^vt (?<pattern>.*)/i,
            :virus_total,
            command: false,
            help: { 'vt PATTERN' => 'Checks virus total for results of PATTERN' }
           )

      route(/^virus total (?<pattern>.*)/i,
            :virus_total,
            command: false,
            help: { 'virus total PATTERN' => 'Checks virus total for results of PATTERN' }
           )

      def virus_total(response)
        match = response.match_data[:pattern]
        message = case match
                  when /\S+\.\S+/
                    url_report match
                  else
                    file_report match
                  end

        response.reply message
      end

      private

      def header(key, result)
        positive_results = "#{result.fetch('positives', '?')}/#{result.fetch('total', '?')} positive results"
        "#{key} had #{positive_results} on #{result.fetch('scan_date', 'Date Unknown')}"
      end

      def report(key, result)
        data = []
        data << header(key, result)
        positives = positive_list result
        data << "Positive scans: #{positives}" if positives.any?
        data << "Full report: #{result.fetch('permalink', 'Link Unavailable')}"

        data.join "\n"
      end

      def positive_list(result)
        result.fetch('scans', 'Unknown' => 'detected').map { |k, v| k if v['detected'] }.compact
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
