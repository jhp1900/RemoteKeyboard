import QtQuick 2.0

import "../js/componentCreation.js" as ChScript;

Rectangle {
    id: chRoot;
    width: 80;
    height: 60;
    color: "red";

    property string chName: "CH1";
    property string idCard: "CH";   // CH ; CH- ; PS ;

    property int y2;

    Text {
        anchors.centerIn: parent;
        text: chName;
    }
    MouseArea {
        anchors.fill: parent;
        drag.target: chRoot;
        onClicked: {
            console.log(chName);
        }
    }

    Component.onCompleted: {
//        if (idCard !== "PS")
//            animBig.start();
//        else
//            animBig1.start();
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
}
