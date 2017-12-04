import QtQuick 2.0

import "../js/componentCreation.js" as ChScript;

Rectangle {
    id: chRoot;
    width: 100;
    height: 80;
    radius: 5
    color: "#77cccccc";

    property string chName: "CH1";
    property int chType: -1;   // 0-未使能; 1-没有预置位的通道; 2-带预置位的通道; 3-预置位;
    property int y2;
    property bool stateEnable: true;

    signal chClicked(string name);
    signal chDbClicked(string name);

    Text {
        anchors.centerIn: parent;
        font.pixelSize: 28;
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
                console.log("clicked" + chName);
                emit: chClicked(chName);
            }
        }
        onDoubleClicked: {
            if (stateEnable) {
                console.log("Double Clicked" + chName);
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

    onChTypeChanged: {
        switch(chType) {
        case 0:
            animBig.start();
            chRoot.stateEnable = false;
            break;
        case 1:
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
            ChScript.createChObj(chRoot.x, chRoot.y - 300, chName + "-1", 3, chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y - 200, chName + "-2", 3, chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y - 100, chName + "-3", 3, chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y + 100, chName + "-4", 3, chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y + 200, chName + "-5", 3, chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y + 300, chName + "-6", 3, chRoot.y);
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
}
