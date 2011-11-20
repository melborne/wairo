# encoding: UTF-8
require "nokogiri"
require "open-uri"
autoload :YAML, "psych"
autoload :YAML, "yaml"

module Wairo
  CURRENT_DIR = File.expand_path(File.dirname(__FILE__))
  class Scraper
    URL = "http://www.colordic.org/w/"
    class << self
      def build
        @html ||= get(URL)
        parse @html
      end

      def to_file(io=CURRENT_DIR+'/wairo.yml')
        raise IOError, "File exist:#{io}" if File.exist?(io)
        File.open(io, 'w') { |f| YAML.dump build, f }
      end

      def to_yaml
        YAML.dump build
      end

      def get(url)
        @html = Nokogiri::HTML(open url)
      rescue OpenURI::HTTPError => e
        STDERR.puts "HTTP Access Error:#{e}"
        exit
      end

      def parse(html)
        q = Hash.new{ |h,k| h[k]=[] }
        table = html.css("table.colortable")
        table.css("td>a").each do |tda|
          name, hex = tda.attr('title').split(/\s+/)
          url = tda.attr('href')
          subname = tda.css('span').text
          rgb, notes = nil, nil
          q[:wairo] << [name, hex, rgb, subname, url, notes]
        end
        q
      end
    end
  end
end
