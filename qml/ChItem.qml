import QtQuick 2.0

import "../js/componentCreation.js" as ChScript;

Rectangle {
    id: chRoot;
    width: 80;
    height: 60;
    radius: 5
    color: "#77cccccc";

    property string chName: "CH1";
    property string idCard: "CH";   // CH ; CH- ; PS ;
    property int y2;

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
        anchors.fill: parent;
        drag.target: chRoot;
        onClicked: {
            //console.log("clicked" + chName);
            emit: chClicked(chName);
        }
        onDoubleClicked: {
            //console.log("Double Clicked" + chName);
            emit: chDbClicked(chName);
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

    function beformCreat() {
        if (idCard !== "PS")
            animBig.start();
        else
            animDown.start();
    }

    function creatPreset() {
        if (idCard === "CH-") {
            ChScript.createChObj(chRoot.x, chRoot.y - 300, chName + "-1", "PS", chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y - 200, chName + "-2", "PS", chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y - 100, chName + "-3", "PS", chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y + 100, chName + "-4", "PS", chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y + 200, chName + "-5", "PS", chRoot.y);
            ChScript.createChObj(chRoot.x, chRoot.y + 300, chName + "-6", "PS", chRoot.y);
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
