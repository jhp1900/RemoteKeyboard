import QtQuick 2.0

Rectangle {
    id: chDeskRoot;
    width: 1920;
    height: 196;
    color: "transparent";
    visible: false;

    signal switchPVW(string name);
    signal switchPGM(string name);

    ChDeskItem {
        id: ch1;
        x: 7;
        chName: "CH1";
    }
    ChDeskItem {
        id: ch2;
        x: 246;
        chName: "CH2";
    }
    ChDeskItem {
        id: ch3;
        x: 485;
        chName: "CH3";
    }
    ChDeskItem {
        id: ch4;
        x: 724;
        chName: "CH4";
    }
    ChDeskItem {
        id: ch5;
        x: 964;
        chName: "CH5";
    }
    ChDeskItem {
        id: ch6;
        x: 1202;
        chName: "CH6";
    }
    ChDeskItem {
        id: ch7;
        x: 1442;
        chName: "CH7";
    }
    ChDeskItem {
        id: ch8;
        x: 1680;
        chName: "CH8";
    }

    Connections {
        target: win;
        onShowCH: {
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

    function show() {
        visible = true;
        animBig.start();
    }

    function hide() {
        animSmall.start();
    }

    function onSwitchPVWF(name) {
        emit: switchPVW(name);
    }
    function onSwitchPGMF(name) {
        emit: switchPGM(name);
    }

    PropertyAnimation {
        id: animBig;
        target: chDeskRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 0;
        to: 1;
    }
    PropertyAnimation {
        id: animSmall;
        target: chDeskRoot;
        duration: 500;
        easing.type: Easing.OutBounce;
        property: "scale";
        from: 1;
        to: 0;
    }
}
