import QtQuick 2.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.12
//import SddmComponents 2.0

Item {
    id: root

    property string userName: userModel.lastUser
    property string currentIconPath: usersList.currentItem.iconPath
    property string currentUserName: usersList.currentItem.userName


    Rectangle {
        width: parent.width
        height: parent.height
        color: "transparent"
        ListView {
            id: usersList
            visible: false
            z: 2
            anchors {
                top: userNameText.bottom
                left: userNameText.left
                topMargin: 50
            }

            model: userModel
            delegate: Rectangle {
                id: userItem
                color: "transparent"

                width: userNameText.width*2
                height: 50


                function select() {
                    usersList.currentIndex = index
                    currentIconPath = icon
                    currentUserName = name
                }
                Component.onCompleted: {
                    if (name === userModel.lastUser) {
                        userItem.select()
                    }
                    userItem.select()
                }

                Text {
                    id: userItemText
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    text: model.name
                    font.pixelSize: 30
                }
                Rectangle {
                    anchors.fill: parent
                    z: -1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        userItem.select();
                        usersList.visible = false;
                    }
                }

            }
        }
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
                                                    userIcon.width,
                                                    userIcon.height)
                        height: userIcon.adapt ? userIcon.height : width
                        radius: Math.min(width, height)
                    }
                }
            }
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                radius: parent.width / 2
                border.color: "white"
                border.width: 2
            }
        }
        Text {
            id: userNameText
            text: root.currentUserName
            color: textColor
            font.pixelSize: 34
            anchors {
                verticalCenter: userIcon.verticalCenter
                left: userIcon.right
                leftMargin: hMargin
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    usersList.visible = usersList.visible ? false: true;
                }
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
            border.color: "#555555"
            border.width: 1.5
            color: "#ffffff"

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
                    sddm.login(userNameText.text, passwdInput.text, sessionModel.lastIndex)
                }
                Timer {
                    interval: 200
                    running: true
                    onTriggered: passwdInput.forceActiveFocus()
                }

            }
        }
        Rectangle {
            id: loginButton
            color: "#f09745"
            width: root.width/2
            height: 40
            radius: 4
            anchors {
                top: passwdInputZone.bottom
                topMargin: vMargin
                horizontalCenter: passwdInputZone.horizontalCenter
            }
            Text {
                text: "Log in"
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    sddm.login(userNameText.text, passwdInput.text, sessionModel.lastIndex)
                }
            }
        }
    }
}
