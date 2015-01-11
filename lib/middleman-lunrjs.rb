require "middleman-core"
require "middleman-lunrjs/extension"

::Middleman::Extensions.register(:lunrjs) do
  require "middleman-lunrjs/extension"
  ::Middleman::Indexer::Lunrjs
end