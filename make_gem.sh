#!/bin/sh
if [ -f middleman-lunrjs-0.0.1.gem ]; then
    echo "Delete File!"
    rm middleman-lunrjs-0.0.1.gem
    gem uninstall middleman-lunrjs
fi
gem build middleman-lunrjs.gemspec
gem install middleman-lunrjs-0.0.1.gem --local
