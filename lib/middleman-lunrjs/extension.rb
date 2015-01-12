module Middleman
  module Indexer
    class Lunrjs < Middleman::Extension
      # Options
      option :file_path, nil, 'The path where it saves the json file'
      option :index_tags, [], 'are tags in yaml or data file for search'

      def initialize(app, options_hash={}, &block)
        puts ('Init lunrjs ')
        super
        return unless app.environment == :build
        opts = options.dup.to_h
        opts.delete_if { |k, v| v.nil? }
        tags_search = opts[:index_tags]
        file_path = opts[:file_path]
        mi_array = Array.new
        app.ready do
          if file_path.nil?
            file_path = app.inst.source.to_s + '/json/search.json'
          end
          puts 'File Path json '+file_path
          sitemap.resources.each do |resource|
            tags_search.each do |tag_search|
              puts 'Name tag '+ tag_search
              puts 'Url of site ' + resource.url
              puts 'Tags for search ' + resource.data[tag_search].to_s
            end
          end
        end
      end
    end
  end
end