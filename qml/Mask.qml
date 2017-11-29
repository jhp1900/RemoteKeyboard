import QtQuick 2.0

Rectangle {
    //anchors.fill: getRoot(this)
    color: 'lightgrey'
    opacity: 0.5
    z:99
    MouseArea {
        anchors.fill: parent;
        onPressed:{
             mouse.accepted = true
        }
    }
}
