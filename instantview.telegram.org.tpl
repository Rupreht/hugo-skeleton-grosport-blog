# This sample template explores how we can turn the Telegram blog post on the left into an Instant View page as shown on the right — in several simple steps. If you're unsure what some of the elements used here do, check out the full documentation here: https://instantview.telegram.org/docs

# Place the version at the beginning of template. We recommend always using the latest available version of Instant View.
~version: "2.0"

### STEP 1: Define which pages get Instant View and which don't

# That's easy because we only need IV pages for posts on the Telegram blog.
# This *condition* does the trick.
?path: /blog/.+

### STEP 2: Define the essential elements

# Now we'll start filling up the IV page.
# To make things easier, we'll begin by storing the actual body of the post in a *variable* before we start our manipulations.
$main: //div[@id="dev_page_content_wrap"]

# The 'title' and 'body' *properties* are required for an Instant View page to work, so we'll define those two. 
title:  $main//h1[1]
body:  //div[@id="dev_page_content"]
# While we're at it, we'll move the signature to the top of the page.
author: "Telegram"

### Now to set the cover image. This isn't required, but we need a cover image if we want our Instant view page to look cool.

# Telegram blog posts always have their cover in a div of the "blog_wide_image" class, so we'll look for that one.
cover: $main//*[has-class("blog_wide_image")]//img
# Note that 'cover:' is a *property*, so by default it will not be overwritten after we've assigned a value to it for the first time. This means that the rule below will not be applied if the first one already hit the target.
# Read more about properties here: https://instantview.telegram.org/docs#properties
cover: $main//img[has-class("blog_wide_image")]

### Set the link preview image. Links shared via Telegram will show an extended preview with a small picture. We'll also use the cover as the image in those previews.
image_url:   $cover/self::img/@src

# But we've only introduced covers to our blog posts in the Fall of 2016.
# So for any old posts that don't have a cover, we'll use the smaller monochromatic image for link previews (but not for the cover, they're too small).
$side_image: $main//img[has-class("blog_side_image")]
image_url:   $side_image/@src
# Regardless of whether we're using a cover image or not, there's no proper space for the small monochromatic image on the IV page.
# So we'll just get rid of it using the '@remove' *function*.
@remove:     $side_image

# Properly display media and the respective captions.
# Replace //div tags with <figcaption> and <figure> tags.
<figcaption>: $body//div[has-class("blog_image_wrap")]/p
<figure>:     $body//div[has-class("blog_image_wrap")]
<figure>:     $body//div[has-class("blog_side_image_wrap")]
<figure>:     $body//div[has-class("smartphone_video_player_wrap")]

## STEP 3: Cleanup

@remove: $body//*[has-class("twitter_timeline_wrap")]
@remove: $body/div/center[.//img]/br

# Remove "The Telegram Team" italic footer with the date from the page. We already have this info on the Instant View page, just below the title, no need to repeat it at the bottom.
$footer: $body/p[./em[contains(., "The Telegram Team")]]
@remove: $footer/prev-sibling::*[./br][not(normalize-space())]
@remove: $footer/next-sibling::*[./br][not(normalize-space())]
@remove: $footer

### STEP 4: Further refinements

### Telegram blog posts have a 'Recent News' section at the bottom (on the right on desktops) that features earlier blog posts. We'll make some changes to this block so that it looks better on the IV page.

$related:  //div[has-class("tl_blog_bottom_blog")]
<h4>:      $related//a[has-class("side_blog_header")]
<related>: $related
@append_to($body)

### And that's it, we're done. Now the rules from the '..after' block will be applied and the Instant View page is ready. Feel free to click on the panel below to see what exactly is done in the '..after' section.
