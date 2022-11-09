import QtQuick 2.2
import QtGraphicalEffects 1.12

Image {
        id: root

        property bool rounded: true
        property bool adapt: true
        property int size: 80
        property bool with_border: true
 
        width: size
        height: size

        layer.enabled: rounded
        layer.effect: OpacityMask {
            maskSource: Item {
                width: root.width
                height: root.height
                Rectangle {
                    anchors.centerIn: parent
                    width: root.adapt ? root.width : Math.min(
                                                root.width, root.height)
                    height: root.adapt ? root.height : width
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
