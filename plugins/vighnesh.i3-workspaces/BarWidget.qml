import QtQuick
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// Stock i3bar workspace buttons: only workspaces that exist are listed, each a
// 1px-bordered box in i3's default focused/active/inactive/urgent colors.
BarWidget {
  id: root
  moduleName: "vighnesh.i3-workspaces"

  function workspaces() {
    var list = []
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      if (values[i].id > 0) list.push(values[i])
    }

    list.sort(function(left, right) { return left.id - right.id })
    return list
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  implicitWidth: row.implicitWidth
  implicitHeight: barSize

  Row {
    id: row
    anchors.verticalCenter: parent.verticalCenter
    spacing: 1

    Repeater {
      model: root.workspaces()

      Rectangle {
        required property var modelData

        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData.id
        readonly property bool shown: modelData.active === true

        width: label.implicitWidth + 12
        height: root.barSize - 2
        color: modelData.urgent ? "#900000" : focused ? "#285577" : shown ? "#5f676a" : "#222222"
        border.width: 1
        border.color: modelData.urgent ? "#2f343a" : focused ? "#4c7899" : "#333333"

        Text {
          id: label
          anchors.centerIn: parent
          text: modelData.name
          textFormat: Text.PlainText
          color: modelData.urgent || parent.focused || parent.shown ? "#ffffff" : "#888888"
          font.family: "Iosevka"
          font.pixelSize: 13
        }

        MouseArea {
          anchors.fill: parent
          onClicked: root.focusWorkspace(modelData.id)
        }
      }
    }
  }
}
