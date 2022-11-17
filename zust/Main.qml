import QtQuick 2.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.12
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480

    readonly property int vMargin: 40
    readonly property int hMargin: 30
    readonly property color textColor: "#ffffff"

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: config.background
        }
        Item {
            id: timeArea
            width: timeText.width + dateText.width + hMargin
            height: parent.height / 5
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: timeText
                color: textColor
                font.pixelSize: 66
                anchors {
                    top: parent.top
                    topMargin: vMargin
                }
                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 3
                    horizontalOffset: 2
                    color: "#80000000"
                    radius: 1
                    samples: 3
                }
                function updateTime() {
                    text = new Date().toLocaleString(Qt.locale("en_US"),
                                                     "hh:mm")
                }
            }
            Text {
                id: dateText
                color: textColor
                font.pixelSize: 48
                anchors {
                    top: parent.top
                    topMargin: vMargin + 18
                    left: timeText.right
                    leftMargin: hMargin
                }
                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 3
                    horizontalOffset: 2
                    color: "#80000000"
                    radius: 1
                    samples: 3
                }
                function updateDate() {
                    text = new Date().toLocaleString(Qt.locale("en_US"),
                                                     "dd MMMM, dddd")
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    timeText.updateTime()
                    dateText.updateDate()
                }
            }
            // Do time and date updating when timeArea is displayed
            Component.onCompleted: {
                timeText.updateTime()
                dateText.updateDate()
            }
        }

        LoginFrame {
            id: loginFrame
            width: parent.width / 3
            height: parent.height / 3
            anchors {
                centerIn: parent
            }
            Rectangle {
                id: loginFrameBackground
                z: -1
                anchors.fill: parent
                radius: 8
                border.color: "#ffffff"
                color: "#7fffffff"
            }
            FastBlur {
                id: fastBlur
                z: -2
                anchors.fill: loginFrameBackground
                source: ShaderEffectSource {
                    sourceItem: backgroundImage

                    sourceRect: Qt.rect(fastBlur.width, fastBlur.height,
                                        fastBlur.width, fastBlur.height)
                }
                radius: 32
            }
        }
        SessionChoose {
            id: sessionChoose

            width: parent.width / 20
            height: 40
            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: hMargin
                bottomMargin: 10
            }
        }
        SystemButtons {
            id: systemButtons

            width: parent.width / 5
            height: 40
            anchors {
                right: parent.right
                bottom: parent.bottom
                leftMargin: hMargin
                bottomMargin: 10
            }
        }
    }
}
