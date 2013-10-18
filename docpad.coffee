# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://readk.it"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.website.com',
				'website.herokuapp.com'
			]

			# The default title of our website
			title: "Readk.it"

			# The website description (for SEO)
			description: """
				Readk.it is a responsive EPUB reading system taking advantage of the abilities of modern web browsers to allow an attractive reading experience on all manner of devices. Readk.it is free for all to use and adapt.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				Readk.it, EPUB, responsive, reading system
				"""

			# The website author's name
			author: "Jason Darwin"

			# The website author's email
			email: "jcdarwin@gmail.com"

			# Styles
			styles: [
				"http://yui.yahooapis.com/pure/0.3.0/pure-min.css"
				"../../styles/responsive-nav.css"
				"../../styles/style.css"
				"../../styles/fontello.css"
			]

			# Scripts
			scripts: [
				# "scripts/responsive-nav.min.js"
			]

			# Services: https://github.com/docpad/docpad-plugin-services
			services:
				twitterTweetButton: "nzmebooks"
				twitterFollowButton: "nzmebooks"
				githubFollowButton: "jcdarwin"
				googleAnalytics: "UA-35204180-2"


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()

	plugins:
	    ghpages:
	        deployRemote: 'github'
	        deployBranch: 'gh-pages'
}


# Export our DocPad Configuration
module.exports = docpadConfig
