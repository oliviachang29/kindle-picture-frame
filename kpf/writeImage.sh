eips -c
eips -c
/mnt/us/linkss/bin/convert /mnt/us/kpf/screensaver.jpg -filter LanczosSharp -brightness-contrast 0x20 -resize x800 -gravity center -crop 600x800+0+0 +repage -colorspace Gray -dither FloydSteinberg -remap /mnt/us/kpf/kindle_colors.gif -quality 75 -define png:color-type=0 -define png:bit-depth=8 screensaver.png
rm screensaver.jpg
/mnt/us/kpf/fbink/bin/fbink -i /mnt/us/kpf/screensaver.png -g halign=CENTER,valign=CENTER,w=600,h=800