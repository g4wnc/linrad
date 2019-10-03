# Linrad on the Raspberry Pi with Buster
This basic script has been produced to simplify the installation of the excellent Linrad software on a Raspberry Pi-3B or 4B running Raspbian Buster.
The script begins by installing the prerequisite packages and continues by installing the radio drivers for: Airspy receivers (all models), RTL-SDR based dongles and Mirics based receivers including SDRPlay.
This is followed by the installation of Linrad itself.
Once complete, Linrad is started by entering the following:
```
cd ~/linrad
./xlinrad
```
Linrad gives the user far more control than any other SDR software but that does mean there is a very steep learning curve. There are some excellent tutorials to be found on the web. I recommend you start with the [linrad site](http://www.sm5bsz.com/linuxdsp/usage/newco/newcomer.htm)

Mike - G4WNC
