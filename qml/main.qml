import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.2

import "../js/componentCreation.js" as ChScript;

Window {
    id: win
    visible: true
    width: Screen.desktopAvailableWidth;
    height: Screen.desktopAvailableHeight;
    //visibility: Window.FullScreen;
    title: qsTr("RemoteKeyboard")
    flags: Qt.WindowMinMaxButtonsHint | Qt.Window;

    signal destroyCH(string name);
    signal switchToActivity(string pgmName, string pvwName);
    signal refeshCH(string name, int chType);
    signal removePS(string name);
    signal sendActionToCH(string action);

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
            width: 150;
            height: 150;
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
            id: ctrlDesk;
            x: (win.width - ctrlDesk.width) / 2;
            y: 550;
        }

        StateBar {
            id: stateBar;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.top: parent.top;
            anchors.topMargin: 10;
        }

        Rectangle {
            width: 50;
            height: 50;
            anchors.top: menuBtn.top;
            anchors.right: menuBtn.left;
            anchors.rightMargin: 10;
            color: "blue";
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    emit: sendActionToCH("Collect");
                    console.log("sendAction over!!!\n");
                }
            }
        }
    }

    //
    Connections {
        target: menuBar;
        onChangeWinSize: {
            if (maxWin)
                win.visibility = Window.FullScreen;
            else
                win.visibility = Window.AutomaticVisibility;
        }
    }

    // C++ Call QML ****************************************************************
    Connections {
        target: dispatching
        onCallQmlRefeshImg: {
            for (var i = 0; i < 5; ++i) {
                img.source = ""
                img.source = "image://provider"
            }
        }
        onCallQmlLoadupCh: {
            var gap = Math.floor((win.width - 120) / (count + 1));
            var h = (win.height - 100) / 2;
            console.log("onCallQmlRefeshCh : " + name + " - " + count + " - " + index + " - " + chType + " - " + gap + " - " + h);
            ChScript.createChObj(gap * index, h, name, chType, 0);
        }
        onCallQmlRefeshCh: {
            if (refType === 1) {
                var w = win.width - 150;
                var h = (win.height - 80) / 2;
                ChScript.createChObj(w, h, name, chType, 0);
            } else if (refType === -1) {
                emit: destroyCH(name);
            } else if (refType === 0) {
                emit: refeshCH(name, chType);
            }
        }
        onCallQmlChangeChActivity: {
            console.log("onCallQmlChangeChActivity : " + pgmName + " - " + pvwName);
            switchToActivity(pgmName, pvwName);
        }
        onCallQmlCtrlState: {
            if (obj === "DirectMode") {
                ctrlDesk.directMode = val;
                stateBar.directMode = val;
            } else if (obj === "RecodeState") {
                ctrlDesk.recodeState = val;
                stateBar.recodeState = val;
            }
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
        target: ctrlDesk;
        onSendAction: dispatching.onQmlSendAction(action);
    }

    // JS Function *****************************************************************
    function onChClicked(name) {
        //console.log("main qml on clicked + " + name);
        dispatching.onQmlChSwitch(name, true);
    }

    function onChDbClicked(name) {
        //console.log("main qml on double clicked + " + name);
        dispatching.onQmlChSwitch(name, false);
    }

    function onChRemovePS(name) {
        emit: removePS(name);
    }

    function onChSendPoint(name, x, y) {
        dispatching.onQmlSaveCHPoint(name, x, y);
    }
}
