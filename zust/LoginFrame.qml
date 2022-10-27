import QtQuick 2.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.12

//import SddmComponents 2.0
Item {
    id: root

    property string currentIconPath: userModel.data(userModel.index(
                                                        userModel.count - 1,
                                                        0), Qt.UserRole + 4)
    property string currentUserName: userModel.data(userModel.index(
                                                        userModel.count - 1,
                                                        0), Qt.UserRole + 1)

    ComboBox {
        id: usersList

        width: parent.width / 3
        anchors {
            verticalCenter: userIcon.verticalCenter
            left: userIcon.right
            leftMargin: hMargin
        }
        model: userModel

        delegate: ItemDelegate {
            width: parent.width
            contentItem: Text {
                text: model.name
                font.pixelSize: 20
                font.capitalization: Font.Capitalize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: usersList.highlightedIndex === index
            background: Rectangle {
                color: usersList.highlightedIndex === index ? "#555555" : "white"
            }

            function select() {
                usersList.currentIndex = index
                userNameText.text = model.name
                currentIconPath = model.icon
                currentUserName = model.name
            }

            onClicked: select()
        }
        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }
        indicator: Canvas {
            id: canvas

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            width: 12
            height: 8
            contextType: "2d"

            Connections {
                target: usersList
                function onPressedChanged() {
                    canvas.requestPaint()
                }
            }

            onPaint: {
                context.reset()
                context.moveTo(0, 0)
                context.lineTo(width, 0)
                context.lineTo(width / 2, height)
                context.closePath()
                context.fillStyle = usersList.pressed ? "#555555" : "#222222"
                context.fill()
            }
        }
        contentItem: Text {
            id: userNameText

            text: currentUserName
            //color: textColor
            color: "#222222"
            font.pixelSize: 20
            font.bold: true
            font.capitalization: Font.Capitalize
        }
        Component.onCompleted: {
            for (var i = 0; i < userModel.count; i++) {
                var this_username = userModel.data(userModel.index(i, 0),
                                                   Qt.UserRole + 1)
                if (this_username === userModel.lastUser) {
                    currentIndex = +userModel.index(i, 0)
                    currentUserName = this_username
                    currentIconPath = userModel.data(userModel.index(i, 0),
                                                     Qt.UserRole + 4)
                }
            }
        }
    }

    // TODO: Take to a separate component
    Image {
        id: userIcon

        property bool rounded: true
        property bool adapt: true

        anchors {
            top: parent.top
            left: parent.left
            topMargin: 20
            leftMargin: 20
        }
        width: 80
        height: 80
        source: root.currentIconPath

        layer.enabled: rounded
        layer.effect: OpacityMask {
            maskSource: Item {
                width: userIcon.width
                height: userIcon.height
                Rectangle {
                    anchors.centerIn: parent
                    width: userIcon.adapt ? userIcon.width : Math.min(
                                                userIcon.width, userIcon.height)
                    height: userIcon.adapt ? userIcon.height : width
                    radius: Math.min(width, height)
                }
            }
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: parent.width / 2
            border.color: "#222222"
            border.width: 2
        }
    }

    Rectangle {
        id: passwdInputZone

        width: root.width * 0.8
        height: 32
        radius: 4
        anchors {
            centerIn: parent
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        border.color: "#e38131"
        border.width: 1.5

        TextInput {
            id: passwdInput

            anchors {
                fill: parent
                leftMargin: 8
                rightMargin: 20
            }
            font.pixelSize: 16
            clip: true
            echoMode: TextInput.Password
            verticalAlignment: TextInput.AlignVCenter
            onAccepted: {
                sddm.login(userNameText.text, passwdInput.text,
                           sessionModel.lastIndex)
            }
            Timer {
                interval: 200
                running: true
                onTriggered: passwdInput.forceActiveFocus()
            }
        }
    }
    // TODO: Take to a separate component
    Rectangle {
        id: loginButton

        color: loginButtonClickArea.pressed ? "#e38131" : "#f09745"
        width: root.width / 2
        height: 40
        border.color: "#e38131"
        border.width: 2
        radius: 4
        anchors {
            top: passwdInputZone.bottom
            topMargin: vMargin
            horizontalCenter: passwdInputZone.horizontalCenter
        }
        Text {
            text: "Log in"
            color: textColor
            font.pixelSize: 16
            font.bold: true
            anchors.centerIn: parent
        }
        MouseArea {
            id: loginButtonClickArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                sddm.login(userNameText.text, passwdInput.text,
                           sessionModel.lastIndex)
            }
        }
    }
}
