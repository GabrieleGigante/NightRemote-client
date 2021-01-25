# What's this project about?

## TLDR
I hooked up a Raspberry PI to my old smart TV and loaded up [this node script on it](https://github.com/GabrieleGigante/Remote-Client) so that I could control it from a flutter app.

## In depth explaination
So, when I last moved (back in 2016) my dad bought himself a new tv and allowed me to take his old [42 inches LG tv from 2013](https://www.lg.com/us/tvs/lg-42LF5600-led-tv) and it served me well to this day. But it has one major pain: The software experience is **awful**. [The OS is very outdated](https://inventory-photos-0.global.ssl.fastly.net/794833/original/96510292454_1.jpg.jpg?1429722252), apps crash often and the remote barely works. 

So, being the lazy problem solver that I am, I just used a raspberry (connected to one of the hdmi ports of the tv) and a bluetooth keyboard to bybass the painful software experience that came with the stock OS; but eventually I decided to take the extra effort and develop a flutter app in order to make the interaction with my tv slicker.

## Requirements
1. An old tv and device that can run node scripts with a video ouput; I suggest raspberry PI (possibly 3B+ or 4, other versions aren't good for 1080p video streaming)
2. A local wifi network
3. A basic understanding of flutter (and [PlatformChannels](https://flutter.dev/docs/development/platform-integration/platform-channels)), node and websockets

## Features
* by tapping on the "remote" text you can access an input text in which you can set the local address of your node server
* dragging your finger on the app screen moves the cursor on the server device
* tapping the screen will result on a left click on the server
* Tapping the volume buttons on your smartphone will increase and decrease system volume of the server
