import QtQuick 2.6
import QtQuick.Controls 2.2

Item {
    id: root

    property string currentSession: sessionModel.data(
                                        sessionModel.index(
                                            sessionsList.currentIndex, 0),
                                        Qt.UserRole + 4)
    property int currentSessionIndex: sessionsList.currentIndex

    ComboBox {
        id: sessionsList

        function rotateArrow() {
            if (sessionArrow.clickCount == 0) {
                sessionArrow.clickCount++
            } else {
                sessionArrow.rotation = sessionArrow.rotation ? 0 : 180
                sessionArrow.clickCount = 0
            }
        }


        model: sessionModel
        currentIndex: sessionModel.lastIndex

        delegate: ItemDelegate {
            width: parent.width
            contentItem: Text {
                text: model.name
                font.pixelSize: 20
                font.capitalization: Font.Capitalize
            }
            highlighted: sessionsList.highlightedIndex === index

            background: Rectangle {
                color: sessionsList.highlightedIndex === index ? "#555555" : "white"
            }

            onPressedChanged: sessionsList.rotateArrow()
        }
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }
        popup.width: 300

        contentItem: Text {
            id: sessionText
            rightPadding: sessionsList.indicator.width

            verticalAlignment: Text.AlignVCenter

            text: currentSession
            color: "white"
            font.pixelSize: 20
            font.bold: true
            font.capitalization: Font.Capitalize
        }

        indicator: Image {
            id: sessionArrow
            property int clickCount: 0

            anchors {
                left: sessionText.right
                verticalCenter: parent.verticalCenter
            }

            sourceSize.width: 12
            sourceSize.height: 12
            source: "icons/arrow-down-white.png"
            rotation: 180

            Behavior on rotation {
                RotationAnimation {
                    duration: 200
                }
            }

            Connections {
                target: sessionsList
                function onPressedChanged() {
                    sessionsList.rotateArrow()
                }
            }
        }
    }
}
