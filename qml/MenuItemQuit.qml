import QtQuick 2.0

Rectangle {
    id: quitRoot;
    color: "#33000000";
    border.color: "#44cccccc";
    border.width: 1;
    radius: barRoot.width - 4;
    visible: false;

    property int innerX: 2;
    property int innerWidth: barRoot.width - 4;
    property int innerHeight: barRoot.width - 4;

    property int innerY;
    property string showText: "";

    signal clicked();

    Text {
        anchors.centerIn: parent
        font.pixelSize: 28;
        font.bold: true;
        style: Text.Outline;
        styleColor: "#ffffff";
        text: showText;
    }
    MouseArea {
        anchors.fill: parent;
        onClicked: quitRoot.clicked();
    }

    function itemShow() {
        quitRoot.x = innerX;
        quitRoot.y = innerY;
        quitRoot.width = innerWidth;
        quitRoot.height = innerHeight;
        quitRoot.scale = 1;

        visible = true;
        animHeightIncrease.start();
    }

    function itemHide() {
        animHeightDecrease.start();
    }

    Connections {
        target: animHeightDecrease;
        onStopped: visible = false;
    }

    PropertyAnimation {
        id: animHeightIncrease;
        target: quitRoot;
        duration: 250;
        easing.type: Easing.OutBounce;
        property: "height";
        from: 0;
        to: quitRoot.height;
    }
    PropertyAnimation {
        id: animHeightDecrease;
        target: quitRoot;
        duration: 250;
        easing.type: Easing.InExpo;
        property: "height";
        from: quitRoot.height;
        to: 0;
    }
    PropertyAnimation {
        id: animSmall;
        target: quitRoot;
        duration: 100;
        easing.type: Easing.InExpo;
        property: "scale";
        from: 1;
        to: 0;
    }
}
