import QtQuick 2.0

import "../js/componentCreation.js" as ChScript;

Rectangle {
    id: chRoot;
    width: 120;
    height: 100;
    radius: 5
    color: "#77cccccc";
    z: 50

    property string chName: "CH1";
    property int chType: -1;   // 0-未使能; 1-没有预置位的通道; 2-带预置位的通道; 3-预置位;
    property int y2;
    property bool stateEnable: true;
    property int chSpace: 120;
    property int rx;
    property int ry;

    signal chClicked(string name);
    signal chDbClicked(string name);
    signal chRemovePS(string name);
    signal chSendPoint(string name, int x, int y);

    Text {
        anchors.centerIn: parent;
        font.pixelSize: 34;
        font.bold: true;
        style: Text.Outline;
        styleColor: "#ffffff";
        text: chName;
    }
    MouseArea {
        id: mouseArea;
        anchors.fill: parent;
        drag.target: chRoot;
        onClicked: {
            if (stateEnable) {
                //console.log("clicked" + chName);
                emit: chClicked(chName);
            }
        }
        onDoubleClicked: {
            if (stateEnable) {
                //console.log("Double Clicked" + chName);
                emit: chDbClicked(chName);
            }
        }
    }

    PropertyAnimation {
        id: animBig;
        target: chRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
        onStopped: creatPreset();
    }
    PropertyAnimation {
        id: animSmall;
        target: chRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
        onStopped: chRoot.destroy();
    }
    PropertyAnimation {
        id: animDown;
        target: chRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "y";
        from: y2;
        to: y;
    }
    PropertyAnimation {
        id: animMoveX;
        target: chRoot;
        duration: 500;
        easing.type: Easing.OutExpo;
        property: "x";
        from: x;
        to:rx;
    }
    PropertyAnimation {
        id: animMoveY;
        target: chRoot;
        duration: 500;
        easing.type: Easing.OutExpo;
        property: "y";
        from: y;
        to: ry;
    }

    onChTypeChanged: {
        switch(chType) {
        case 0:
            animBig.start();
            chRoot.stateEnable = false;
            break;
        case 1:
            emit: chRemovePS(chName);
            animBig.start();
            chRoot.stateEnable = true;
            break;
        case 2:
            animBig.start();
            chRoot.stateEnable = true;
            break;
        case 3:
            animDown.start();
            break;
        }

        console.log("OnChTypeChanged : " + chName + " - " + chType);
    }

    function creatPreset() {
        if (chType === 2) {
            var h = win.height;
            if (h < 7 * chRoot.chSpace) {
                chRoot.chSpace = h / 7;
            }
            var chY = -3;
            var yTop = chRoot.y > -chY * chRoot.chSpace;
            var yBottom = chRoot.y + (chY+7) * chRoot.chSpace < h;
            while (!(yTop && yBottom)) {
                if (!yTop)
                    ++chY;
                else if (!yBottom)
                    --chY;

                yTop = chRoot.y > -chY * chRoot.chSpace;
                yBottom = chRoot.y + (chY+7) * chRoot.chSpace < h;
            }

            if (chY === -7)
                chY = -6;

            for(var i = 1; i < 7; ++i){
                if (chY === 0)
                    ++chY;
                ChScript.createChObj(chRoot.x, chRoot.y + chY * chRoot.chSpace, chName + "-" + i, 3, chRoot.y);
                ++ chY;
            }
        }
    }

    function onDestroyCH(name) {
        var subName = chName;
        var end = chName.indexOf('-');
        if (end > 0)
            subName = chName.substring(0, end);
        if (subName === name)
            animSmall.start();
    }

    function onSwitchToActivity(pgm_name, pvw_name) {
        if (chName === pgm_name)
            color = "#77ff0000";
        else if (chName === pvw_name)
            color = "#7700ff00";
        else
            color = "#77cccccc";
    }

    function onRefeshCH(name, chType) {
        if (chName !== name)
            return;
        chRoot.chType = chType;
        console.log(" - - - - On Refesh CH Changed : " + name + " - " + chType);
    }

    function onRemovePS(name) {
        var end = chName.indexOf('-');
        if (end > 0) {
            var subName = chName.substring(0, end);
            if (subName === name)
                animSmall.start();
        }
    }

    function onSendActionToCH(action) {
        if (action === "Collect")
            chSendPoint(chName, chRoot.x, chRoot.y);
            //console.log(chRoot.chName + " POINT : " + chRoot.x + " - - " + chRoot.y);
    }

    function onRestoreChPoint(name, x, y) {
        if (chName === name) {
            chRoot.rx = x;
            chRoot.ry = y;
            animMoveX.start();
            animMoveY.start();
        }
    }
}
