require "middleman-core"
require 'v8'
require 'json'
require "middleman-lunrjs/extension"

::Middleman::Extensions.register(:lunrjs) do
  require "middleman-lunrjs/extension"
  ::Middleman::Indexer::Lunrjs
end