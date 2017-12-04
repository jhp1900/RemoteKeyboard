
var comCH;

function createChObj(x, y, name, chType, y2) {
    comCH = Qt.createComponent("../qml/ChItem.qml");
    if (comCH.status === Component.Ready || comCH.status === Component.Error)
        finishChCreation(x, y, name, chType, y2);
}

function finishChCreation(x, y, name, chType, y2) {
    if (comCH.status === Component.Ready) {
        var item = comCH.createObject(win, {"x": x, "y": y});
        if (item === null) {
            console.log("Error creating object");
        } else {
            item.chName = name;
            item.y2 = y2;
            item.chType = chType;
            win.destroyCH.connect(item.onDestroyCH);
            win.switchToActivity.connect(item.onSwitchToActivity);
            item.chClicked.connect(win.onChClicked);
            item.chDbClicked.connect(win.onChDbClicked);
        }
    } else if (comCH.status === Component.Error) {
        console.log("Error loading component: ", comCH.errorString());
    }
}
