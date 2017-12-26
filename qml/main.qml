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

    signal showCH(string name);
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

        RecodDesk {
            id: recodeDesk;
            x: 5;
            y: 250;
        }

        ChDesk {
            id: chDesk;
            x: 0;
            y: 448;
        }

        DirectorDesk {
            id: directorDesk;
            x: 5;
            y: 675;
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

        Rectangle {
            id: test;
            width: 70; height: 70;
            anchors.top: menuBtn.top;
            anchors.right: menuBtn.left;
            anchors.rightMargin: 10;
            color: "red";
            MouseArea {
                anchors.fill: parent;
                onClicked: dispatching.stop();
            }
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
//            showCHFounction(name, chType);
//            chDesk.showCh(name);
        }
        onCallQmlRefeshCh: {
            if (refType === 1) {
//                showCHFounction(name, chType);
//                chDesk.show(name);
            } else if (refType === -1) {
                emit: destroyCH(name);
            } else if (refType === 0) {
                emit: refeshCH(name);
            }
        }
        onCallQmlChangeChActivity: {
            console.log("onCallQmlChangeChActivity : " + pgmName + " - " + pvwName);
            emit: switchToActivity(pgmName, pvwName);
        }
        onCallQmlCtrlState: {
            if (obj === "DirectMode") {
                directorDesk.directMode = val;
                //stateBar.directMode = val;
            } else if (obj === "RecodeState") {
                recodeDesk.recodeState = val;
                //stateBar.recodeState = val;
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
            if (isFront) {
                initRK();
            } else {
                menuBar.show();
            }
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
        target: directorDesk;
        onSendAction: dispatching.onQmlSendAction(action);
    }
    Connections {
        target: recodeDesk;
        onSendAction: dispatching.onQmlSendAction(action);
    }
    Connections {
        target: menuBar;
        onOpenVK: dispatching.onQmlVK();
    }
    Connections {
        target: chDesk;
        onSwitchPVW: dispatching.onQmlChSwitch(name, true);
        onSwitchPGM: dispatching.onQmlChSwitch(name, false);
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

    function initRK() {
        dispatching.onQmlGetInitData();
        recodeDesk.show();
        directorDesk.show();
        chDesk.show();
        linkHomeSet.linkHome();
    }
}
