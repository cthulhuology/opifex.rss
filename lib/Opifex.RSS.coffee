# Opifex.RSS.coffee
#
#	© 2013 Dave Goehrig <dave@dloh.org>
#

FeedParser = require 'feedparser'
http = require('http')
https = require('https')

OpifexRSS = () ->
	# A bucket to contain the IDs of all the feed's we're parsing
	self = this
	self.feeds = {}
	self.protocols = 'http': http, 'https': https
	# Fetches Url once every Interval minutes
	self.connect = (Url, Interval) ->
		Interval ||=  1
		if not self.feeds[Url]
			console.log "Watching #{Url}"
			self.feeds[Url] = setInterval(() ->
				console.log "Fetching #{Url}"
				[ protocol ] = Url.match(///([^:]+)///)[1...]
				self.protocols[protocol]?.get Url, (res) ->
					console.log "Got response #{ res.statusCode }"
					res.pipe(new FeedParser( feedurl: Url )).
					on('error', (error) -> console.log "Error: #{error}").
					on('meta', (meta) -> 
						console.log "Meta: #{meta}"
						console.log "#{ k } => #{meta[k]}" for k of meta
					).
					on('article', (article) ->
						self.send [ "rss.article", article ] if article
					).
					on('end', () -> console.log "Sleeping....")
			, Interval * 60000)

	# List the current list of URLs it is fetching
	self.list = () ->
		self.send [ "rss.feeds", k for k of self.feeds ]

	# Cancels the stream
	self.cancel = (Url) ->
		if self.feeds[Url]
			clearInterval(self.feeds[Url])
			delete self.feeds[Url]
			self.send [ "rss.cancel", Url ]

	# Does not understand message
	self["*"] = (message...) ->
		console.log "Unknown message #{ JSON.stringify(message) }"

module.exports = OpifexRSS
