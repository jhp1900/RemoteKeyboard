import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Window 2.2
//import QtQuick

import "../js/componentCreation.js" as ChScript;

Window {
    id: win
    visible: true
//    width: Screen.desktopAvailableWidth;
//    height: Screen.desktopAvailableHeight;
    width: 1920;
    height: 1080;
    visibility: Window.AutomaticVisibility;     // 下策，然，若全屏则导致平板无法调出文件对话框和触摸键盘
//    visibility: Window.FullScreen;
    title: qsTr("RemoteKeyboard")
    flags: Qt.WindowMinMaxButtonsHint | Qt.Window;

    property bool firstClick: true;

    signal destroyCH(string name);
    signal switchToActivity(string pgmName, string pvwName);
    signal refeshCH(string name, int chType);
    signal removePS(string name);
    signal sendActionToCH(string action);
    signal initData(string bkUrl, string bkImg, string ip, string port);

    Rectangle {
        anchors.fill: parent;

        Image {
            id: img
            anchors.fill: parent
            source: "qrc:/res/bk.png"
            MouseArea {
                anchors.fill: parent;
                onClicked: menuBar.hide();
            }
        }

        MenuBtn {
            id: menuBtn;
            anchors.top: parent.top;
            anchors.topMargin: 10;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
        }

        MenuBar {
            id: menuBar;
            anchors.left: menuBtn.left;
            anchors.top: menuBtn.top;
        }

        Background {
            id: bk;
            x: (win.width - bk.width) / 2;
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
    }

//    Component.onCompleted: {
//        console.log("fjdksajfkldsakldsnavkdsajkfjdsknvf----------------------");
//        dispatching.onQmlGetBkurlMsg(true);
//    }

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
        onCallQmlSendInitData: {
            emit: initData(bkUrl, bkImg, ip, port);
            if (isImg) {
                if (bkImg !== "") {
                    img.source = "";
                    img.source = bkImg;
                    console.log(" - onCallQmlSendInitData - bkImg -" + bkImg);
                }
            } else {
                if (bkUrl !== "") {
                    dispatching.onQmlStart(bkUrl, bkImg, isImg);
                    console.log(" - onCallQmlSendInitData - bkUrl -" + bkUrl);
                }
            }
        }
    }

    // QML Call C++ ****************************************************************
    Connections {
        target: menuBtn;
        onClickMenuBtn: {
            if (isFront)
                dispatching.onQmlGetInitData();
            else
                menuBar.show();
        }
    }
    Connections {
        target: bk;
        onClickStart: {
            if (isImg) {
                img.source = "";
                img.source = bkImg;
            }
            dispatching.onQmlStart(bkUrl, bkImg, isImg);
        }
    }
    Connections {
        target: linkHomeSet
        onClickLinkHome: dispatching.onQmlStartKepplive(ip, port);
    }
    Connections {
        target: ctrlDesk;
        onSendAction: dispatching.onQmlSendAction(action);
    }
    Connections {
        target: menuBar;
        onSaveCfg: {
            emit: sendActionToCH("Collect");
        }
        onOpenVK: dispatching.onQmlVK();
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
