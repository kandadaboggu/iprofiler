# Iprofiler

Ruby wrapper for the [Iprofile API](http://www.iprofile.net/developer). Heavily inspired by [Wynn Netherland's](https://github.com/pengwynn) [LinkedIn gem](https://github.com/pengwynn/linkedin).

Travis CI : [![Build Status](https://secure.travis-ci.org/kandadaboggu/iprofiler.png)](http://travis-ci.org/kandadaboggu/iprofiler)

## Installation

    [sudo] gem install iprofiler

## Usage

    require 'rubygems'
    require 'iprofiler'

    # get your api keys at https://www.linkedin.com/secure/developer
    client = Iprofiler::Client.new('your_consumer_key', 'your_consumer_secret')
    reply = client.company_lookup(:ip_address => "10.10.20.30")
    if reply.status == :found
      company = reply.company
      if company.type == :isp
      else
      end
    else
      reply.code
      reply.message
    end

## TODO


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2013 [Harish Shetty](http://kandadaboggu.com). See LICENSE for details.
