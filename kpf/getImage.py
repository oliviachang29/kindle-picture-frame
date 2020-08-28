import requests
import random

r = requests.get('https://kpf.netlify.app/')

randomImageUrl = random.choice(r.content.decode("utf-8").split(',')).strip()

img = requests.get(randomImageUrl)

with open('screensaver.jpg', 'wb') as f:
	f.write(img.content)