import QtQuick 2.0

Rectangle {
    id: chDeskRoot;
    width: 1920;
    height: 196;
    color: "transparent";

    signal switchPVW(string name);
    signal switchPGM(string name);

    ChDeskItem {
        id: ch1;
        chName: "CH1";
        anchors.left: parent.left;
        anchors.leftMargin: 6;
    }
    ChDeskItem {
        id: ch2;
        anchors.left: ch1.right;
        anchors.leftMargin: 3;
        chName: "CH2";
    }
    ChDeskItem {
        id: ch3;
        anchors.left: ch2.right;
        anchors.leftMargin: 3;
        chName: "CH3";
    }
    ChDeskItem {
        id: ch4;
        anchors.left: ch3.right;
        anchors.leftMargin: 3;
        chName: "CH4";
    }
    ChDeskItem {
        id: ch5;
        anchors.left: ch4.right;
        anchors.leftMargin: 3;
        chName: "CH5";
    }
    ChDeskItem {
        id: ch6;
        anchors.left: ch5.right;
        anchors.leftMargin: 3;
        chName: "CH6";
    }
    ChDeskItem {
        id: ch7;
        anchors.left: ch6.right;
        anchors.leftMargin: 3;
        chName: "CH7";
    }
    ChDeskItem {
        id: ch8;
        anchors.left: ch7.right;
        anchors.leftMargin: 3;
        chName: "CH8";
    }

    Connections {
        target: win;
        onShowCH: {
            if (name === "CH1") ch1.onRefeshCH(name, 0);
            else if (name === "CH2") ch2.onRefeshCH(name, 1);
            else if (name === "CH3") ch3.onRefeshCH(name, 1);
            else if (name === "CH4") ch4.onRefeshCH(name, 1);
            else if (name === "CH5") ch5.onRefeshCH(name, 1);
            else if (name === "CH6") ch6.onRefeshCH(name, 1);
            else if (name === "CH7") ch7.onRefeshCH(name, 1);
            else if (name === "CH8") ch8.onRefeshCH(name, 1);
        }
    }
    Connections {
        target: ch1;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch2;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch3;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch4;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch5;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch6;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch7;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }
    Connections {
        target: ch8;
        onSwitchPVW: onSwitchPVWF(name);
        onSwitchPGM: onSwitchPGMF(name);
    }

    function onSwitchPVWF(name) {
        emit: switchPVW(name);
    }
    function onSwitchPGMF(name) {
        emit: switchPGM(name);
    }
}
