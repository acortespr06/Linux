import requests
import feedparser

# Replace this with your new RSS feed URL and webhook URL
rss_feed_url = 'https://www.livechart.me/feeds/episodes'
webhook_url = 'https://media.guilded.gg/webhooks/e63b5cef-ed66-4555-bf9e-e5c2329d40fc/4pY5P6CDmgwS4qAemuMkkYuUk6Ia6GAgEmOieQW8IWQSSsYciQaGoYYac4wy6qYS4uI2i0KMK2y8SU4I4og2KO'

try:
    # Fetch and parse the RSS feed
    feed = feedparser.parse(rss_feed_url)

    # Check if the feed has entries
    if not feed.entries:
        raise ValueError('No entries found in the RSS feed.')

    # Process each entry
    for entry in feed.entries:
        title = entry.title
        link = entry.link
        description = entry.description if hasattr(entry, 'description') else ''

        # Get the thumbnail URL from the enclosure element
        thumbnail_url = entry.enclosures[0].href if 'enclosures' in entry and entry.enclosures else None

        # Format data for the webhook with the requested format
        content = f'**{title}**\n{description}\n\n[Read more]({link})'

        # Include the thumbnail in the content if available
        if thumbnail_url:
            content += f'\n![Thumbnail]({thumbnail_url})'

        # Send data to the webhook
        response = requests.post(webhook_url, json={'content': content})

        # Check the response
        if response.status_code == 200:
            print(f'Webhook successfully triggered for {title}')
        else:
            print(f'Error: {response.status_code} for {title}')
            print(response.text)

except Exception as e:
    print(f'An error occurred: {str(e)}')
