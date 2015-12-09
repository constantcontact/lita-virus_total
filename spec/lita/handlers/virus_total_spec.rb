require 'spec_helper'

describe Lita::Handlers::VirusTotal, lita_handler: true do
  let(:response) do
    {
      'positives' => 1,
      'scans' => { 'useless' => 'nope', 'boring' => 'nope', 'awesome' => 'detected' },
      'total' => 3,
      'permalink' => 'http://url.to.thing',
      'scan_date' => 'today!'
    }
  end

  let(:clean_response) do
    {
      'positives' => 0,
      'scans' => { 'useless' => 'nope', 'cool' => 'nope', 'awesome' => 'nope' },
      'total' => 3,
      'permalink' => 'http://url.to.thing',
      'scan_date' => 'today!'
    }
  end

  before :each do
    allow(Lita.config.handlers.virus_total).to receive(:api_key).and_return 'api key'
  end

  it { is_expected.to route('vt asdf').to :virus_total }
  it { is_expected.to route('virus total asdf').to :virus_total }

  context '#virus_total' do
    context 'responds with' do
      it 'does not blow up if missing stuff' do
        expect(Uirusu::VTUrl).to receive(:query_report).with('api key', 'asdf.com').and_return({})
        send_message 'vt asdf.com'
        message = <<MESSAGE
asdf.com had ?/? positive results on Date Unknown
Positive scans: [\"Unknown\"]
Full report: Link Unavailable
MESSAGE
        expect(replies.last).to eq(message.strip)
      end
      it 'a formatted string for urls' do
        expect(Uirusu::VTUrl).to receive(:query_report).with('api key', 'asdf.com').and_return(response)
        send_message 'vt asdf.com'
        message = <<MESSAGE
asdf.com had 1/3 positive results on today!
Positive scans: [\"awesome\"]
Full report: http://url.to.thing
MESSAGE
        expect(replies.last).to eq(message.strip)
      end

      it 'a formatted string for urls with no positives' do
        expect(Uirusu::VTUrl).to receive(:query_report).with('api key', 'asdf.com').and_return(clean_response)
        send_message 'vt asdf.com'
        message = <<MESSAGE
asdf.com had 0/3 positive results on today!
Full report: http://url.to.thing
MESSAGE
        expect(replies.last).to eq(message.strip)
      end

      it 'prints a formatted string for files' do
        expect(Uirusu::VTFile).to receive(:query_report).with('api key', 'asdf').and_return(response)
        send_message 'vt asdf'
        message = <<MESSAGE
asdf had 1/3 positive results on today!
Positive scans: [\"awesome\"]
Full report: http://url.to.thing
MESSAGE
        expect(replies.last).to eq(message.strip)
      end

      it 'a formatted string for files with no positives' do
        expect(Uirusu::VTFile).to receive(:query_report).with('api key', 'asdf').and_return(clean_response)
        send_message 'vt asdf'
        message = <<MESSAGE
asdf had 0/3 positive results on today!
Full report: http://url.to.thing
MESSAGE
        expect(replies.last).to eq(message.strip)
      end
    end

    it 'parses files' do
      expect(Uirusu::VTFile).to receive(:query_report).with('api key', 'asdf').and_return(response)
      send_message 'vt asdf'
    end

    it 'parses dns' do
      expect(Uirusu::VTUrl).to receive(:query_report).with('api key', 'asdf.com').and_return(response)
      send_message 'vt asdf.com'
    end

    it 'parses urls' do
      expect(Uirusu::VTUrl).to receive(:query_report).with('api key', 'http://asdf.com').and_return(response)
      send_message 'vt http://asdf.com'
    end

    it 'handles bad urls' do
      expect(Uirusu::VTFile).to receive(:query_report).with('api key', 'http://asdf asdf').and_return(response)
      send_message 'vt http://asdf asdf'
    end
  end
end
