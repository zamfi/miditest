import themidibus.*;
MidiBus myBus; // The MidiBus

import processing.sound.*;

SinOsc[] sineWaves; 

// The number of oscillators
int numSines = 5; 

// A float for calculating the amplitudes
float[] sineVolume;


void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  // Either you can
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  // or you can ...
  //                   Parent         In                   Out
  //                     |            |                     |
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.

  // or for testing you could ...
  //                 Parent  In        Out
  //                   |     |          |
  myBus = new MidiBus(this, "USB Keystation 88es", -1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  
  // Create the oscillators and amplitudes
  sineWaves = new SinOsc[numSines];
  sineVolume = new float[numSines]; 

  for (int i = 0; i < numSines; i++) {
    
    // The overall amplitude shouldn't exceed 1.0 which is prevented by 1.0/numSines.
    // The ascending waves will get lower in volume the higher the frequency
    sineVolume[i] = 0;
    
    // Create the Sine Oscillators and start them
    sineWaves[i] = new SinOsc(this);
    sineWaves[i].amp(0);
    sineWaves[i].play();
  }
}

void draw() {
}

int lastSine = 0;

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  SinOsc wave = sineWaves[lastSine++];
  wave.freq(6.875 *(pow(2.0,((3.0+(pitch))/12.0))));
  wave.amp((float) velocity / 127.0);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  // Receive a noteOff - or releasing the note from your midi device
  SinOsc wave = sineWaves[--lastSine];
  wave.amp(0);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}