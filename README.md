# Middleman::Lunrjs

This is a plugin the lunr-js for middleman

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman-lunrjs'
```

And then execute:

    $ bundle 

Or install it yourself as:

    $ gem install middleman-lunrjs

You can install the gem in local with shell script 

    $ ./make_gem.sh

You have to install lunr.js into the javascript folder of middlemanapp project

    $ bower install lunr.js

## Usage
Put in Gemfile the Middleman extension lunrjs

    $ gem "middleman-lunrjs"

and config.rb 

    configure :build do
        activate :lunrjs do |config|
         config.index_tags = %w(title ) # Optional Hash with tags of metadata
         config.file_path # Optional folder where save index json file. By default "source/json/search.json".
         config.lunr_config # Optional Hash with config of lunrjs. See http://lunrjs.com/docs/#lunr
         config.lunr_javascript_dir = /source/javascripts/bower_components/lunr.js/lunr.js # Optional directory + file where the lunar.js is. 
        end
    end

## Contributing

1. Fork it ( https://github.com/jnovos/middleman-lunrjs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

