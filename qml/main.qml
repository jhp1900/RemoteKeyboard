import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.2

import "../js/componentCreation.js" as ChScript;

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
            MouseArea {
                anchors.fill: parent;
                onClicked: menuBar.hide();
            }
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
                anchors.fill: parent;
                onClicked: menuBar.show();
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
            y: 150;
        }

        LinkHomeSet {
            id: linkHomeSet
            x: (win.width - linkHomeSet.width) / 2;
            y: 300;
        }

        Rectangle {
            id: randomAdd
            width: 50; height: 50;
            anchors.top: menuBtn.top;
            anchors.right: menuBtn.left
            anchors.rightMargin: 10;
            color: "#06849d"
            Text {
                anchors.centerIn: parent;
                text: "Random"
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    console.log("Click Random Add");
                    ChScript.createChObj(600, 500, "CH2", "CH-", 0);
                }
            }
        }

        Rectangle {
            id: firstAdd
            width: 50; height: 50;
            anchors.top: menuBtn.top;
            anchors.right: randomAdd.left
            anchors.rightMargin: 10;
            color: "#06849d"
            Text {
                anchors.centerIn: parent;
                text: "First"
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    console.log("Click First Add");
                    ChScript.createChObj(100, 100, "CH1", "CH", 0);
                    ChScript.createChObj(300, 500, "CH2", "CH-", 0);
                }
            }
        }
    }

    Connections {
        target: bkUrlSet;
        onClickStart: dispatching.start(url);
    }

    Connections {
        target: linkHomeSet
        onClickLinkHome: dispatching.startKepplive(ip, port);
    }
}
