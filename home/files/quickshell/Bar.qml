// Bar.qml
import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root

  // Propriétés pour stocker les données
  property string time: ""
  property string batteryLevel: ""
  property string batteryStatus: ""
  property string networkStatus: ""
  property var workspaces: []

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: "transparent"
      implicitHeight: 28

      anchors {
        top: true
        left: true
        right: true
      }

      // Conteneur principal avec Row pour organiser les widgets
      Row {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 0

        // Section gauche - Workspaces
        Item {
          width: parent.width / 3
          height: parent.height

          Row {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Repeater {
              model: root.workspaces

              Rectangle {
                required property var modelData
                width: 32
                height: 24
                radius: 4
                color: modelData.focused ? "#89b4fa" : (modelData.visible ? "#585b70" : "#313244")
                border.color: modelData.focused ? "#b4befe" : "transparent"
                border.width: 1

                Text {
                  anchors.centerIn: parent
                  text: modelData.num
                  color: modelData.focused ? "#1e1e2e" : "#cdd6f4"
                  font.pixelSize: 12
                  font.bold: modelData.focused
                }

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: {
                    // Changer de workspace au clic
                    switchWorkspaceProc.command = ["swaymsg", "workspace", "number", modelData.num.toString()]
                    switchWorkspaceProc.running = true
                  }
                }
              }
            }
          }
        }

        // Section centre - Heure/Date
        Item {
          width: parent.width / 3
          height: parent.height

          Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: "🕐"
              color: "#cdd6f4"
              font.pixelSize: 14
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: root.time
              color: "#cdd6f4"
              font.pixelSize: 13
              font.family: "monospace"
            }
          }
        }

        // Section droite - Réseau et Batterie
        Item {
          width: parent.width / 3
          height: parent.height

          Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

            // Widget Réseau
            Row {
              spacing: 6
              anchors.verticalCenter: parent.verticalCenter

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.networkStatus === "full" ? "🌐" : "📡"
                color: root.networkStatus === "full" ? "#a6e3a1" : "#f9e2af"
                font.pixelSize: 14
              }

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.networkStatus === "full" ? "Connecté" : "Limité"
                color: "#cdd6f4"
                font.pixelSize: 12
              }
            }

            // Widget Batterie
            Row {
              spacing: 6
              anchors.verticalCenter: parent.verticalCenter

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: {
                  if (root.batteryStatus === "Charging") return "⚡"
                  var level = parseInt(root.batteryLevel)
                  if (level > 80) return "🔋"
                  if (level > 50) return "🔋"
                  if (level > 20) return "🪫"
                  return "🪫"
                }
                color: {
                  if (root.batteryStatus === "Charging") return "#a6e3a1"
                  var level = parseInt(root.batteryLevel)
                  if (level > 20) return "#a6e3a1"
                  return "#f38ba8"
                }
                font.pixelSize: 14
              }

              Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.batteryLevel + "%"
                color: "#cdd6f4"
                font.pixelSize: 12
              }
            }
          }
        }
      }
    }
  }

  // Process pour l'heure/date
  Process {
    id: dateProc
    command: ["date", "+%H:%M:%S - %d/%m/%Y"]
    running: true

    stdout: SplitParser {
      onRead: data => root.time = data.trim()
    }
  }

  // Process pour la batterie
  Process {
    id: batteryProc
    command: ["sh", "-c", "cat /sys/class/power_supply/macsmc-battery/capacity"]
    running: true

    stdout: SplitParser {
      onRead: data => root.batteryLevel = data.trim()
    }
  }

  Process {
    id: batteryStatusProc
    command: ["sh", "-c", "cat /sys/class/power_supply/macsmc-battery/status"]
    running: true

    stdout: SplitParser {
      onRead: data => root.batteryStatus = data.trim()
    }
  }

  // Process pour le réseau
  Process {
    id: networkProc
    command: ["nmcli", "-t", "-f", "CONNECTIVITY", "general"]
    running: true

    stdout: SplitParser {
      onRead: data => root.networkStatus = data.trim()
    }
  }

  // Process pour récupérer les workspaces Sway
  Process {
    id: workspacesProc
    command: ["sh", "-c", "swaymsg -t get_workspaces | tr -d '\\n'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        if (data.trim().length === 0) return
        try {
          const parsed = JSON.parse(data)
          // Trier par numéro de workspace
          root.workspaces = parsed.sort((a, b) => a.num - b.num)
        } catch (e) {
          console.log("Error parsing workspaces:", e, "Data:", data)
        }
      }
    }
  }

  // Process pour changer de workspace (utilisé par le MouseArea)
  Process {
    id: switchWorkspaceProc
    running: false
  }

  // Souscription aux événements Sway pour mettre à jour en temps réel
  Process {
    id: swayEventsProc
    command: ["sh", "-c", "swaymsg -t subscribe -m '[\"workspace\"]' | while read line; do echo update; done"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        // Dès qu'un événement workspace arrive, on met à jour
        if (data.trim() === "update") {
          workspacesProc.running = true
        }
      }
    }
  }

  // Timer pour mettre à jour toutes les secondes
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      dateProc.running = true
      batteryProc.running = true
      batteryStatusProc.running = true
      networkProc.running = true
      workspacesProc.running = true
    }
  }
}
