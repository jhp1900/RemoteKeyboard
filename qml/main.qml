import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.2

Window {
    id: win
    visible: true
    width: Screen.width;
    height: Screen.height;
    title: qsTr("RemoteKeyboard")
    flags: Qt.WindowSystemMenuHint | Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint | Qt.Window

    Rectangle {
        anchors.fill: parent;

        Image {
            id: img
            anchors.fill: parent
            source: "image://provider"
        }

        Connections {
            target: dispatching
            onCallQmlRefeshImg: {
                img.source = ""
                img.source = "image://provider"
            }
        }

        Rectangle {
            id: menuBtn;
            width: 80;
            height: 80;
            anchors.top: parent.top;
            anchors.topMargin: 10;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            color: "red"

            MouseArea {
                id:btnMenu;
                anchors.fill: parent;
                onClicked: {
                    menuBar.show();
                }
            }
        }

        MenuBar {
            id: menuBar;
            anchors.left: menuBtn.left;
            anchors.top: menuBtn.bottom;
        }

        BkUrlSet {
            id: bkUrlSet
            x: (win.width - bkUrlSet.width) / 2;
            y: (win.height - bkUrlSet.height) / 2;
        }

        MouseArea {
            anchors.fill: bkUrlSet;
            drag.target: bkUrlSet;
            drag.axis: Drag.XAndYAxis
        }
    }


}
