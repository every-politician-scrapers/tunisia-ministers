#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

require 'open-uri/cached'

class WikipediaDate
  # Ukrainian dates
  class French < WikipediaDate
    REMAP = {
      'en cours'  => '',
      'januar'    => 'January',
      'février'   => 'February',
      'mars'      => 'March',
      'avril'     => 'April',
      'mai'       => 'May',
      'juin'      => 'June',
      'juillet'   => 'July',
      'août'      => 'August',
      'septembre' => 'September',
      'octobre'   => 'October',
      'novembre'  => 'November',
      'décembre'  => 'December',
    }.freeze

    def remap
      super.merge(REMAP)
    end

    def date_str
      super.gsub('1er', '1')
    end
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Image'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[image name party color cabinet start end].freeze
    end

    def empty?
      false
    end

    def endDate
      super rescue binding.pry
    end

    def date_class
      WikipediaDate::French
    end

    def tds
      noko.css('td,th')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
