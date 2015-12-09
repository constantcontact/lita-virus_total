# lita-virus_total

[![Build Status](https://travis-ci.org/constantcontact/lita-virus_total.png?branch=master)](https://travis-ci.org/constantcontact/lita-virus_total)
[![Coverage Status](https://coveralls.io/repos/constantcontact/lita-virus_total/badge.png)](https://coveralls.io/r/constantcontact/lita-virus_total)

Adds the capability to call the virus total api to scan for file hashes and urls.

## Installation

Add lita-virus_total to your Lita instance's Gemfile:

``` ruby
gem "lita-virus_total"
```

## Configuration

Add your api to to lita:

```ruby
Lita.configure do |config|
...
  config.handlers.virus_total.api_key = ENV['VIRUS_TOTAL_KEY']
...
```

## Usage

The plugin adds two routes that both call the virus total api. Both routes can take a url/dns or a file hash.

`vt PATTERN` or `virus total PATTERN`

Both of these will report the positives/total, the date last scanned and a link to the full report. If there are any positive results then they will also list the scans that had hits.
