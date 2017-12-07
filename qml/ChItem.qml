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
            var chY = -3;
            var h = win.height;
            var yTop = chRoot.y > chY*-100;
            var yBottom = chRoot.y + (chY+7)*100 < h;
            while (!(yTop && yBottom)) {
                if (!yTop)
                    ++chY;
                else if (!yBottom)
                    --chY;

                yTop = chRoot.y > chY*-100;
                yBottom = chRoot.y + (chY+7)*100 < h;
            }

            if (chY === -7)
                chY = -6;

            for(var i = 1; i < 7; ++i){
                if (chY === 0)
                    ++chY;
                ChScript.createChObj(chRoot.x, chRoot.y + chY*100, chName + "-" + i, 3, chRoot.y);
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
}
