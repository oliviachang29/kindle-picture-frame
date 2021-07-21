import requests

img = requests.get('https://k4nt-weather-display.s3.us-west-1.amazonaws.com/weather-script-output.png', allow_redirects=True)

with open('weather-script-output.png', 'wb') as f:
	f.write(img.content)