
// a tool to search midi files by melodic contour, put midi files in the data folder

import javax.sound.midi.*;

String searchFor = "uuusuddduusddu";// u = up ; d = down ; s = same

void setup() {
  size(500, 500);
  String path = dataPath("");
  File folder = new File(path);
  File[] listOfFiles = folder.listFiles();

  for (File file : listOfFiles) {
    if (file.isFile() && (file.getName().endsWith(".midi")||file.getName().endsWith(".mid"))) {
      processMidiFile(file);
    }
  }
  exit();
}

void processMidiFile(File midiFile) {
  try {
    Sequence sequence = MidiSystem.getSequence(midiFile);
    int trackNumber = 0;
    for (Track track : sequence.getTracks()) {
      trackNumber++;
      String contour = contour(track);
      if (contour.indexOf(searchFor)!=-1) println(midiFile.getName()+" : "+contour.indexOf(searchFor));
      // println(midiFile.getName()+" : "+contour);
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

String contour(Track track) {
  String contour = "";
  int previousNote = -1;

  for (int i = 0; i < track.size(); i++) {
    MidiEvent event = track.get(i);
    MidiMessage message = event.getMessage();

    if (message instanceof ShortMessage) {
      ShortMessage sm = (ShortMessage) message;

      if (sm.getCommand() == ShortMessage.NOTE_ON) {
        int note = sm.getData1();
        int velocity = sm.getData2();
        if (velocity>0) {
          if (previousNote >= 0) {
            if (note > previousNote) contour+="u";
            else if (note < previousNote) contour+="d";
            else contour+="s";
          }
          previousNote = note;
        }
      }
    }
  }
  return contour;
}

void draw() {
}
