# encoding: UTF-8
module Wairo
  require_relative 'wairo/scraper'
  require_relative 'wairo/color'
  class Wairo
    class << self
      attr_reader :series, :colors
      def init
        wairo = load_build_file || Scraper.build
        @series = wairo.keys
        @colors = build_colors(wairo)
      end

      def color(name)
        @colors.detect { |c| c.name == name }
      end

      def colors_in_series(series)
        @colors.select { |c| c.series == series }
      end

      def color_names(sub=false)
        @colors.map do |c|
          sub ? "#{c.name}(#{c.subname})" : c.name
        end
      end

      private
      def build_colors(wairo)
        tmp = []
        wairo.each do |series, colors|
          colors.each { |attrs| tmp << Color.new(series, *attrs) }
        end
        tmp
      end

      def load_build_file(io=CURRENT_DIR+'/wairo.yml')
        YAML.load_file(io)
      rescue
        nil
      end
    end

    init
  end
end
