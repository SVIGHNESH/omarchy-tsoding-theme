import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui

// Renders the i3bar protocol stream of a real i3status process: white
// statusline text, per-block colors, and i3bar's 1px separator in a 9px gap.
BarWidget {
  id: root
  moduleName: "vighnesh.i3status"

  property var blocks: []

  readonly property string configPath: setting("config", Qt.resolvedUrl("i3status.conf").toString().replace("file://", ""))

  function updateLine(line) {
    var json = String(line || "").replace(/^,/, "")
    if (json.charAt(0) !== "[" || json.length < 2) return

    try {
      root.blocks = JSON.parse(json)
    } catch (e) {
      // Partial line — keep the previous blocks.
    }
  }

  implicitWidth: row.implicitWidth + 4
  implicitHeight: barSize

  Process {
    id: proc
    command: ["i3status", "-c", root.configPath]
    running: true
    stdout: SplitParser { onRead: function(line) { root.updateLine(line) } }
    onExited: restartTimer.start()
  }

  Timer {
    id: restartTimer
    interval: 5000
    onTriggered: proc.running = true
  }

  Row {
    id: row
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
      model: root.blocks

      Row {
        required property var modelData
        required property int index

        Item {
          visible: index > 0
          width: 9
          height: label.implicitHeight

          Rectangle {
            anchors.centerIn: parent
            width: 1
            height: parent.height - 4
            color: "#666666"
          }
        }

        Text {
          id: label
          text: modelData.full_text || ""
          textFormat: Text.PlainText
          color: modelData.color || "#ffffff"
          font.family: "Iosevka"
          font.pixelSize: 13
        }
      }
    }
  }
}
