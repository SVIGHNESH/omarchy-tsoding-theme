import QtQuick
import Quickshell.Io
import qs.Ui

// i3bar cannot be rearranged with the mouse, but the Omarchy bar reorders a
// widget on any small drag and moves to another screen edge when its empty
// space is dragged. This invisible widget only exists in the tsoding theme's
// layout, and puts that layout back whenever it drifts.
BarWidget {
  id: root
  moduleName: "vighnesh.i3bar-lock"

  implicitWidth: 0
  implicitHeight: 0

  Process {
    id: lockProc
    command: ["bash", Qt.resolvedUrl("lock-layout").toString().replace("file://", "")]
  }

  // Polled rather than watched: shell.json is replaced on every write, and a
  // file watch can stop delivering events after that.
  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: lockProc.running = true
  }
}
