import requests

img = requests.get('https://picsum.photos/600/800?grayscale', allow_redirects=True)

with open('screensaver.jpg', 'wb') as f:
	f.write(img.content)