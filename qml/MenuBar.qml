import QtQuick 2.7

Rectangle {
    id: barRoot
    color: "#33000000"
    border.color: "#44ffffff";
    border.width: 1;
    radius: 75
    visible: false;

    property int innerWidth: menuBtn.width;
    property int innerHeight: 760;

    signal saveCfg();
    signal openVK();

    Rectangle {
        id: columnLay
        width: barRoot.width;
        height: barRoot.height;
        anchors.centerIn: parent;
        color: "#00000000"

        MenuItem {
            id: itemSaveCfg;
            innerY: 152;
            showText: "保存配置";
            onClicked: {
                emit: saveCfg();
                hide();
            }
        }
        MenuItem {
            id: itemBk;
            innerY: 244;
            showText: "背景流";
            onClicked: {
                bk.show();
                hide();
            }
        }
        MenuItem {
            id: itemHome;
            innerY: 336;
            showText: "连接主机";
            onClicked: {
                linkHomeSet.show();
                hide();
            }
        }
        MenuItem {
            id: itemCtrl;
            innerY: 428;
            showText: "控制台";
            onClicked: {
                ctrlDesk.show();
                hide();
            }
        }
        MenuItem {
            id: itemKey;
            innerY: 520;
            showText: "触摸键盘";
            onClicked: {
                emit: openVK();
                hide();
            }
        }
        MenuItemQuit {
            id: itemQuit;
            innerY: 612;
            showText: "退出";
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
            itemSaveCfg.itemShow();
            itemBk.itemShow();
            itemHome.itemShow();
            itemCtrl.itemShow();
            itemKey.itemShow();
            itemQuit.itemShow();
        }
    }

    function hide() {
        itemSaveCfg.itemHide();
        itemBk.itemHide();
        itemHome.itemHide();
        itemCtrl.itemHide();
        itemKey.itemHide();
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
