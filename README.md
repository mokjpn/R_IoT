# R_IoT
an example shiny application to collect and visualize sensor data from IoT devices into R 

Demo movie: https://www.youtube.com/watch?v=DXHfFZz9q1M

"ownTracks" tab receives location data provided by ownTracks app, via mqtt-mongo bridge ( https://github.com/izmailoff/mqtt-mongo ) .
As you move with your phone with ownTracks app, points on the map will be appended.

"BME280" tab receives temperature/humidity/pressure data provided by Espruino+BME280+ESP8266, via ponte MQTT broker's MQTT-HTTP bridge.
The plot of these data will be updated every second.

"KeyButton" tab receives on-off information from Cerevo's Hackey gadget ( http://hackey.cerevo.com/ ) and displays its status. The status will be updated every 500 ms.
As you moves slider on the page, Particle's Internet button ( https://www.particle.io/button ) displays the number by number of lighted LEDs.
( appropreate sketch required on your Photon.)

