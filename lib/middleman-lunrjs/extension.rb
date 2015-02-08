require "middleman-core"
require 'v8'
require 'json'

module Middleman
  module Indexer
    class Lunrjs < Middleman::Extension
      # Options
      option :file_path, nil, 'The path where it saves the json file'
      option :index_tags, [], 'are tags in yaml or data file for search'
      option :lunr_config_id, {:id => 'id'}, 'structure of index'
      option :lunr_config_boost, {:fields => {:title => 10, :path => 20}}, 'structure for boost'

      def initialize(app, options_hash={}, &block)
        puts ('Init lunrjs ')
        super
        return unless app.environment == :build
        opts = options.dup.to_h
        opts.delete_if { |k, v| v.nil? }
        app.before_build do
          opts[:sitemap] = sitemap
          Indexer.new(app, opts)
        end
      end

      class Indexer
        def initialize(app, opts = {})
          puts ' Run Indexer Inizialite '
          tags_search = opts[:index_tags]
          file_path = opts[:file_path]
          lunr_config_id = opts[:lunr_config_id]
          lunr_config_boost = opts[:lunr_config_boost]
          lunr_config = lunr_config_boost.merge(lunr_config_id)
          sitemap = opts[:sitemap]
          folder_root = app.root_path
          folder_source = app.root_path + app.inst.source.to_s
          instsource = app.inst.source.to_s
          docs = Array.new
          folder_json = folder_source.to_s + '/json'
          if !Dir.exist?(folder_json)
            Dir.mkdir(folder_json)
          end
          if file_path.nil?
            file_path = folder_source.to_s + '/json/search.json'
          end
          sitemap.resources.each do |resource|
            tags_search.each do |tag_search|
              if  resource.data[tag_search] && !resource.url.to_s.start_with?('/localizable/')
                doc = Hash[:id => resource.url.to_s, :title => resource.data[tag_search], :path => resource.url.to_s]
                puts 'Name tag '+ tag_search
                puts 'Url of site ' + resource.url
                puts 'Tags for search ' + resource.data[tag_search].to_s
                docs.push(doc)
              end
            end
          end
          if File.exist?(folder_root.to_s + '/.bowerrc')
            file=File.open(folder_root.to_s + '/.bowerrc').read
            data_hash = JSON.parse(file)
            #path of lunr.js folder
            folder_lunar_js = folder_root.to_s + '/' + data_hash['directory'].to_s + '/lunr.js/lunr.js'
          else
            #path of lunr.js folder
            folder_lunar_js = folder_root.to_s + 'bower_components/lunr.js/lunr.js'
          end
          if !File.exist?(folder_lunar_js)
            raise "Could not find lunr.js into #{folder_lunar_js}"
          end
          cxt = V8::Context.new
          cxt.load(folder_lunar_js)
          # add new method to lunr index
          cxt.eval('lunr.Index.prototype.indexJson = function () {return JSON.stringify(this);}')
          #Get the lunjs object
          val = cxt.eval('lunr')
          lunr_conf = proc do |this|
            this.ref('id')
            lunr_config[:fields].each_pair do |name, boost|
              this.field(name, {:boost => boost})
            end
          end
          puts val.version
          #Get the IDX Object
          idx = val.call(lunr_conf)
          docs.each do |doc|
            idx.add(doc)
          end
          total = idx.indexJson()
          File.open(file_path, 'w') { |f| f.write(total) }
        end
      end
    end
  end
end