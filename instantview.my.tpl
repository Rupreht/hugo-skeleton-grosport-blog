# This sample template explores how we can turn the Medium post on the left into a Telegram Instant View page as shown on the right — in several simple steps. If you're unsure what some of the elements used here do, check out the full documentation here: https://instantview.telegram.org/docs

# Place the version at the beginning of template. We recommend always using the latest available version of Instant View.
~version: "2.0"

### STEP 1: Define which pages get Instant View and which don't

# We only want to generate Instant View pages for articles. Other things, like lists of articles, profiles, the about section, etc. should be ignored.
# Conveniently, all article pages on Medium seem to have a <meta property="article:published_time"> tag.
# If this tag is not present, we'll assume that the page is not an article and does not require an Instant View page.
# This *condition* does the trick:
?exists: /html/head/meta[@property="article:published_time"]

### STEP 2: Define the essential elements

# The 'body' and 'title' *properties* are required for an Instant View page to work. 
# 'Subtitle' is optional for IV pages, but Medium posts can have subtitles, so it is essential that we reflect this in our template.
body:     //article
title:    $body//h1[1]
subtitle: $title/next-sibling::h2

### Now we'll set a cover image. It's also not required, but we need one if we want our Instant view page to look cool.

# Some Medium posts have a cover image in the header background, we can use that.
# First, let's assign the background node to the '$bg_section' *variable* for subsequent use.
$bg_section: $body//section[has-class("is-imageBackgrounded")]
# Call the @background_to_image *function* to convert the background image to an <img>
@background_to_image: $bg_section//div[has-class("section-backgroundImage")]
# Replace the //div tag with <figure> tags.
<figure>: $bg_section//div[has-class("section-background")]
# Set the figure as the value of the 'cover' *property*.
cover: $bg_section//figure

### Now to find an image for link previews. Links shared via Telegram will show an extended preview with a small picture in the chat. Let's try to find something for this image.

# If we've already got a cover, we'll use it for the link preview image too.
image_url: $cover/self::img/@src
image_url: $cover/self::figure//img/@src

# If we didn't find a cover, we'll take a picture from the meta tags. 
# Otherwise, the link preview will just have text in it, which is also OK.
image_url: //head/meta[@property="og:image"]/@content

