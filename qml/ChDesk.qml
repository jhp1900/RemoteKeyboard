import QtQuick 2.0

Rectangle {
    id: chDeskRoot;
    width: 1920;
    height: 196;
    color: "transparent";

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
}
