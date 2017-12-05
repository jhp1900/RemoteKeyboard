import QtQuick 2.7

Rectangle {
    id: barRoot
    color: "#3c3c3c"
    visible: false;

    property int innerWidth: menuBtn.width;
    property int innerHeight: 250;

    Rectangle {
        id: columnLay
        width: barRoot.width;
        height: barRoot.height;
        anchors.centerIn: parent;

        color: "#3c3c3c"
        MenuItem {
            id: itemBk;
            innerY: 2;

            showText: "背景流";
            onClicked: {
                bkUrlSet.show();
                hide();
            }
        }
        MenuItem {
            id: itemHome;
            innerY: 64;
            showText: "连接主机";
            onClicked: {
                linkHomeSet.show();
                hide();
            }
        }
        MenuItem {
            id: itemCtrl;
            innerY: 126;
            showText: "控制台";
            onClicked: {
                controlDesk.show();
                hide();
            }
        }
        MenuItem {
            id: itemQuit;
            innerY: 188;
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
            itemBk.itemShow();
            itemHome.itemShow();
            itemCtrl.itemShow();
            itemQuit.itemShow();
        }
    }

    function hide() {
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
