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

    signal destroyCH(string name);
    signal switchToActivity(string pgmName, string pvwName);

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

        Rectangle {
            id: menuBtn;
            width: 120;
            height: 120;
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
            id: bkUrlSet;
            x: (win.width - bkUrlSet.width) / 2;
            y: 50;
        }

        LinkHomeSet {
            id: linkHomeSet;
            x: (win.width - linkHomeSet.width) / 2;
            y: 300;
        }

        ControlDesk {
            id: controlDesk;
            x: (win.width - controlDesk.width) / 2;
            y: 550;
        }
    }

    // C++ Call QML ****************************************************************
    Connections {
        target: dispatching
        onCallQmlRefeshImg: {
            img.source = ""
            img.source = "image://provider"
        }
        onCallQmlLoadupCh: {
            console.log("onCallQmlRefeshCh : " + name + " - " + count + " - " + index + " - " + ch_type);
            var gap = (win.width - count * 100) / (count + 1);
            var h = (win.height - 80) / 2;
            ChScript.createChObj(gap * index, h, name, ch_type, 0);
        }
        onCallQmlRefeshCh: {
            if (ref_type === 1) {
                var w = win.width - 150;
                var h = (win.height - 80) / 2;
                ChScript.createChObj(w, h, name, ch_type, 0);
            } else if (ref_type === -1) {
                emit: destroyCH(name);
            } else if (ref_type === 0) {

            }
        }
        onCallQmlChangeChActivity: {
            console.log("onCallQmlChangeChActivity : " + pgmName + " - " + pvwName);
            switchToActivity(pgmName, pvwName);
        }
    }

    // QML Call C++ ****************************************************************
    Connections {
        target: bkUrlSet;
        onClickStart: dispatching.start(url);
    }
    Connections {
        target: linkHomeSet
        onClickLinkHome: dispatching.startKepplive(ip, port);
    }
    Connections {
        target: controlDesk;
        onSendAction: dispatching.onQmlSendAction(action);
    }

    // JS Function *****************************************************************
    function onChClicked(name) {
        console.log("main qml on clicked + " + name);
        dispatching.onQmlChSwitch(name, true);
    }

    function onChDbClicked(name) {
        console.log("main qml on double clicked + " + name);
        dispatching.onQmlChSwitch(name, false);
    }
}
