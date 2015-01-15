module Middleman
  module Indexer
    class Lunrjs < Middleman::Extension
      # Options
      option :file_path, nil, 'The path where it saves the json file'
      option :index_tags, [], 'are tags in yaml or data file for search'
      option :lunr_config, [], 'structure for '

      def initialize(app, options_hash={}, &block)
        puts ('Init lunrjs ')
        super
        return unless app.environment == :build
        opts = options.dup.to_h
        opts.delete_if { |k, v| v.nil? }
        tags_search = opts[:index_tags]
        file_path = opts[:file_path]
        docs = Array.new
        folder_source = app.root_path + app.inst.source.to_s
        app.ready do
          if file_path.nil?
            file_path = app.inst.source.to_s + '/json/search.json'
          end
          puts 'File Path json '+file_path
          sitemap.resources.each do |resource|
            tags_search.each do |tag_search|
              doc = Hash[:id => resource.url.to_s, :title => resource.data[tag_search], :url => resource.url.to_s]
              puts 'Name tag '+ tag_search
              puts 'Url of site ' + resource.url
              puts 'Tags for search ' + resource.data[tag_search].to_s
              docs.push(doc)
            end
          end
          puts 'start index lunr'
          lunr_config = {
              :ref => 'id',
              :fields => {
                  :title => 10,
                  :path => 20
              },
          }
          folder_source = app.root_path + app.inst.source.to_s
          folder_lunar_js = folder_source.to_s + '/' + app.inst.js_dir.to_s + '/lunr.js/lunr.js'
          @lunr_path = File.exist?(folder_lunar_js) ? folder_lunar_js : File.join(folder_source, File.basename(folder_lunar_js))
          raise "Could not find #{@lunr_path}" if !File.exist?(@lunr_path)
          cxt = V8::Context.new
          cxt.load(@lunr_path)
          #Obtengo el objecto lunr
          val = cxt.eval('lunr')
          lunr_conf = proc do |this|
            this.ref('id')
            lunr_config[:fields].each_pair do |name, boost|
              this.field(name, {:boost => boost})
            end
          end
          puts val.version
          #Obtengo el objecto IDX
          idx = val.call(lunr_conf)
          docs.each do |doc|
            idx.add(doc)
          end
          total = idx.miJson(idx)
          File.open(file_path, 'w') { |f| f.write(total) }
        end
      end
    end
  end
end
