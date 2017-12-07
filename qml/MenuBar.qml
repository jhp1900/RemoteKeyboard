import QtQuick 2.7

Rectangle {
    id: barRoot
    color: "#3c3c3c"
    visible: false;

    property int innerWidth: menuBtn.width;
    property int innerHeight: 312;
    property bool maxWin: false;

    signal changeWinSize(bool maxWin);

    Rectangle {
        id: columnLay
        width: barRoot.width;
        height: barRoot.height;
        anchors.centerIn: parent;
        color: "#3c3c3c"

        MenuItem {
            id: itemWin;
            innerY: 2;
            showText: "全屏";
            onClicked: {
                maxWin = !maxWin;
                emit: changeWinSize(maxWin);
                hide();
                if (maxWin)
                    showText = "恢复";
                else
                    showText = "全屏";
            }
        }
        MenuItem {
            id: itemBk;
            innerY: 64;
            showText: "背景流";
            onClicked: {
                bkUrlSet.show();
                hide();
            }
        }
        MenuItem {
            id: itemHome;
            innerY: 126;
            showText: "连接主机";
            onClicked: {
                linkHomeSet.show();
                hide();
            }
        }
        MenuItem {
            id: itemCtrl;
            innerY: 188;
            showText: "控制台";
            onClicked: {
                ctrlDesk.show();
                hide();
            }
        }
        MenuItem {
            id: itemQuit;
            innerY: 250;
            showText: "Quit";
            onClicked: {
                Qt.quit();
            }
        }
    }

    function show() {
        barRoot.width = innerWidth;
        barRoot.height = innerHeight;
        visible = true;
        animHeightIncrease.start();
    }

    Connections {
        target: animHeightIncrease;
        onStopped: {
            itemWin.itemShow();
            itemBk.itemShow();
            itemHome.itemShow();
            itemCtrl.itemShow();
            itemQuit.itemShow();
        }
    }

    function hide() {
        itemWin.itemHide();
        itemBk.itemHide();
        itemHome.itemHide();
        itemCtrl.itemHide();
        itemQuit.itemHide();
        animHeightDecrease.start();
    }

    Connections {
        target: animHeightDecrease;
        onStopped: visible = false;
    }

    PropertyAnimation {
        id: animHeightIncrease
        target: barRoot
        duration: 100
        easing.type: Easing.InExpo;
        property: "height";
        from: 0;
        to: barRoot.height
    }
    PropertyAnimation {
        id: animHeightDecrease
        target: barRoot
        duration: 250
        easing.type: Easing.InExpo;
        property: "height";
        from: barRoot.height;
        to: 0
    }
}
