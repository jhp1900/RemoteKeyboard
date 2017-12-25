import QtQuick 2.0

import "../js/componentCreation.js" as ChScript;

Rectangle {
    id: chRoot;
    width: 236;
    height: 196;
    anchors.top: parent.top;
    color: "#55000000";
    border.color: "#55ffffff";
    border.width: 1;
    radius: 10;

    property string chName: "CH1";
    property int chType: -1;   // 0-未使能; 1-没有预置位的通道; 2-带预置位的通道; 3-预置位;
    property bool stateEnable: true;

    signal switchPVW(string name);
    signal switchPGM(string name);
    signal chRemovePS(string name);

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
                //emit: chClicked(chName);
                emit: switchPVW(chName);
            }
        }
        onDoubleClicked: {
            if (stateEnable) {
                //console.log("Double Clicked" + chName);
                //emit: chDbClicked(chName);
                emit: switchPGM(chName);
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
}
