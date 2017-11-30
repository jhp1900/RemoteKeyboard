
var comCH;

function createChObj(x, y, name, idCard, y2) {
    comCH = Qt.createComponent("../qml/ChItem.qml");
    if (comCH.status === Component.Ready || comCH.status === Component.Error)
        finishChCreation(x, y, name, idCard, y2);
}

function finishChCreation(x, y, name, idCard, y2) {
    if (comCH.status === Component.Ready) {
        var item = comCH.createObject(win, {"x": x, "y": y});
        if (item === null) {
            console.log("Error creating object");
        } else {
            item.chName = name;
            item.idCard = idCard;
            item.y2 = y2;
            item.beformCreat();
//            sprite.xClicked.connect(doSomething);
//            root.testDestroy.connect(sprite.doDestroy);
        }
    } else if (comCH.status === Component.Error) {
        console.log("Error loading component: ", comCH.errorString());
    }
}

//var comPS;

//function createPsObj(x1, y1, name, y2) {
//    comPS = Qt.createComponent("../qml/ChItem.qml");
//    if (comPS.status === Component.Ready || comPS.status === Component.Error)
//        finishPsCreation(x1, y1, name, y2);
//}

//function finishPsCreation (x1, y1, name, y2) {
//    if (comPS.status === Component.Ready) {
//        var item = comPS.createObject(win, {"x": x1, "y": y1});
//        if (item === null) {
//            console.log("Error creating object");
//        } else {
//            item.chName = name;
//            item.idCard = "PS";
//            item.y2 = y2;
//            item.beformCreat();
////            sprite.xClicked.connect(doSomething);
////            root.testDestroy.connect(sprite.doDestroy);
//        }
//    } else if (comPS.status === Component.Error) {
//        console.log("Error loading component: ", comPS.errorString());
//    }
//}
