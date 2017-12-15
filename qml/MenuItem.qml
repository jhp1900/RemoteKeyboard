import QtQuick 2.0

Rectangle {
    id: itemRoot;
    color: "#00718c";
    border.color: Qt.lighter(color);
    visible: false;

    property int innerX: 2;
    property int innerWidth: barRoot.width - 4;
    property int innerHeight: 90;

    property int innerY;
    property string showText: "";

    signal clicked();

    Text {
        anchors.centerIn: parent
        font.pixelSize: 20;
        text: showText;
    }
    MouseArea {
        anchors.fill: parent;
        onClicked: itemRoot.clicked();
    }

    function itemShow() {
        itemRoot.x = innerX;
        itemRoot.y = innerY;
        itemRoot.width = innerWidth;
        itemRoot.height = innerHeight;
        itemRoot.scale = 1;

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
        target: itemRoot;
        duration: 250;
        easing.type: Easing.OutBounce;
        property: "height";
        from: 0;
        to: itemRoot.height;
    }
    PropertyAnimation {
        id: animHeightDecrease;
        target: itemRoot;
        duration: 250;
        easing.type: Easing.InExpo;
        property: "height";
        from: itemRoot.height;
        to: 0;
    }
    PropertyAnimation {
        id: animSmall;
        target: itemRoot;
        duration: 100;
        easing.type: Easing.InExpo;
        property: "scale";
        from: 1;
        to: 0;
    }
}
