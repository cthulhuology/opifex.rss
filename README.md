Opifex.RSS
=============

Opifex.RSS is an RSS feed reader that generates a stream of messages to AMQP.

Installation
------------

	npm install opifex
	npm install opifex.rss

Usage
-----

From the command line run:

	opifex 'amqp://guest:guest@localhost:5672//rss-in/#/rss/rss-out/rss' rss


Once it is running as specified on the above command,  it will listen on a rss-in exchange for any messages in the rss queue.  It
will then direct all of its output to an rss-out exchange with a routing key of rss.  Feel free to change any of the resource paths
as fits your application.

You can then issue commands to it via AMQP, or if you are running pontifex any of the bridge interfaces. For example you can
run pontifex websocket interface:

	npm install ws
	npm install pontifex
	npm install pontifex.ws

	pontifex 'ws://localhost:8888/' 'amqp://guest:guest@localhost:5672//'

And then use the 'wscat' utility that comes with ws to send commands via the command line:

	> [ "put", "/rss-in/rss", "connect", "https://news.ycombinator.com/rss", 5 ]
	> [ "put", "/rss-in/rss", "list" ]
	> [ "put", "/rss-in/rss", "cancel", "https://news.ycombintator.com/rss" ]


Commands:

	[ "connect", URL, minutes ]	-> watches an RSS feed location, fetching every so many minutes
	[ "list" ] 			-> returns a list of connected urls
	[ "cancel", URL ]		-> stops watching a url, and removes from the list 			



