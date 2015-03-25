# PosterKit iOS Companion App

This is the companion add that goes along with the Processing Multi-Touch poster app - which can be found [here](https://github.com/ltg-uic/processing-poster-client).

There are two basic purposes for this app:

1. Allows users to admin the poster and with the affordance of seeing the what content is being created.
2. Serve as a test client for its services and messaging subsystems.

It connects to a mongo database via a rest service ([DrowsyDromedary](https://github.com/zuk/DrowsyDromedary)) and also talks to an MQTT Service via [MQTT](https://github.com/mobile-web-messaging/MQTTKit).

# Instructions

1. Clone the project. 
2. Install cocoapods 36 pre-release.
3. Run pod install in the working directory.
4. Start up Xcode and run.
