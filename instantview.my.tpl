# This sample template explores how we can turn the Telegraph post on the left into an Instant View page as shown on the right — in several simple steps. If you're unsure what some of the elements used here do, check out the full documentation here: https://instantview.telegram.org/docs

# Place the version at the beginning of template. We recommend always using the latest available version of Instant View.
~version: "2.0"

### STEP 1: Define which pages get Instant View and which don't

# All pages on telegra.ph are articles, with one exception: the main page is blank and lets you create new articles.
# This *condition* tells our Instant View bot to apply rules to all pages except the root page, telegra.ph/
?path: /.+

### STEP 2: Define the essential elements

# Now we'll start filling up the IV page.
# To make things easier, we begin by setting up some *variables* before we start our manipulations.
$header: //header
body:    //article

# By default sequences of whitespaces are collapsed into a single whitespace by the browser. The IV bookworm bot does this too, but Telegra.ph preserves whitespaces in the entire article node.
# So we'll use the '@pre' *function* to instruct the IV bot to preserve whitespaces in all of these nodes.
@pre:    $body//*

# Now to fill the essential properties
title:          $body//h1
subtitle:       $body//h2
author:         $header//address/a[@rel="author"]
author_url:     $author/@href
published_date: $header//address/time/@datetime
@remove:        $body//address

# See if the author name is a URL of a Telegram channel. If it is, assign its username to the *channel* property. This will display the channel name prominently on the Instant View page and add neat 'Join' button for users that are not members of the channel yet.
@clone: $author_url
@match("^https?://t(elegram)?\\.me/([a-z0-9_]+)$", 2, "i"): $@
@replace(".+", "@$0")
channel

cover: $body//h1/next-sibling::figure[.//video]
cover: $body//h1/next-sibling::figure[.//img]
cover: $body//div[2]/div[3]/figure[1]/img
cover: $body/div[2]/picture/img

image_url: $cover/self::img/@src
image_url: $cover/self::figure//img/@src
image_url: /html/head/meta[@property="og:image"] \
             /@content[string()]
image_url: $body//img/@src

# IV supports anchors.
# We can add them before each of h3/h4 headers
@before(<anchor>, name, @id): $body//h3[@id]
@before(<anchor>, name, @id): $body//h4[@id]
