import QtQuick 2.2
import QtQuick.Layouts 1.15

Item {
    id: root
    RowLayout {
        anchors.fill: parent
        ImgButton {
            visible: sddm.canReboot
            TextCaption {
                id: rebootCaption
                visible: false
                text: "Reboot"
            }
            source: "icons/restart.svgz"
            onClicked: sddm.reboot()
            onEntered: rebootCaption.visible = true
            onExited: rebootCaption.visible = false
        }
        ImgButton {
            visible: sddm.canPowerOff
            TextCaption {
                id: powerOffCaption
                visible: false
                text: "Power off"
            }
            source: "icons/shutdown.svgz"
            onClicked: sddm.powerOff()
            onEntered: powerOffCaption.visible = true
            onExited: powerOffCaption.visible = false
        }
        ImgButton {
            visible: sddm.canSuspend
            TextCaption {
                id: suspendCaption
                visible: false
                text: "Suspend"
            }
            source: "icons/suspend.svgz"
            onClicked: sddm.suspend()
            onEntered: suspendCaption.visible = true
            onExited: suspendCaption.visible = false
        }
    }
}
