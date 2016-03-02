// very top!
import processing.sound.*;

// replaces playNotes
void playNotes() {
  int[] oldValues = new int[numSources];
  int[] newValues = new int[numSources];
  int oldPtr = (ptr + numSamples-2) % numSamples;
  int newPtr = (oldPtr + 1) % numSamples;
  for (int source = 0; source < numSources; ++source) {
    oldValues[source] = values[source][oldPtr];
    newValues[source] = values[source][newPtr];
    if (newValues[source] > threshold && oldValues[source] < threshold) {
      noteOn(notes[source], newValues[source]);
    }
    if (newValues[source] < threshold && oldValues[source] > threshold) {
      noteOff(notes[source], newValues[source]);
    }
  }
}

// below this line is all new
HashMap<Integer, SinOsc> hm = new HashMap<Integer, SinOsc>();

void noteOn(int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  SinOsc wave = new SinOsc(this);
  wave.freq(pitch);
  wave.amp((float) velocity / 127.0);
  wave.play();
  synchronized(this) {
    hm.put(pitch, wave);
  }
}

void noteOff(int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  synchronized(this) {
    SinOsc wave = hm.get(pitch);
    wave.stop();
    hm.remove(pitch);
  }
}
