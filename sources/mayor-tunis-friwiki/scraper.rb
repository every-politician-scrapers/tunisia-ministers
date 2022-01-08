#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

require 'open-uri/cached'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  # decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[image name start end].freeze
    end

    def empty?
      false
    end

    def tds
      noko.css('td,th')
    end

    def raw_start
      start_cell.children.map(&:text).map(&:tidy).reject(&:empty?).join(' ').tidy
    end

    def raw_end
      end_cell.children.map(&:text).map(&:tidy).reject(&:empty?).join(' ').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
