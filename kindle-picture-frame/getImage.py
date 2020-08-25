import requests

r = requests.get('https://picsum.photos/600/800?grayscale', allow_redirects=True)

with open('screensaver.jpg', 'wb') as f:
	f.write(r.content)