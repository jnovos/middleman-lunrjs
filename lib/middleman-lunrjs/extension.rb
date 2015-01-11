module Middleman
  module Indexer
    class Lunrjs < Middleman::Extension
      def initialize(app, options_hash={}, &block)
        super
        return unless app.environment == :build
        opts = options.dup.to_h
        opts.delete_if { |k, v| v.nil? }
        app.ready do
          puts ('Init lunrjs ')
          sitemap.resources.each do |resource|
          end
        end
      end
    end
  end
end