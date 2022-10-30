import QtQuick 2.2

Item {
    id: root

    signal clicked
    signal entered
    signal exited

    property string source
    property int size: 30

    width: size
    height: size

    Image {
        anchors.fill: parent
        source: parent.source
    }
    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onClicked: parent.clicked()
        onEntered: parent.entered()
        onExited: parent.exited()
    }
}
