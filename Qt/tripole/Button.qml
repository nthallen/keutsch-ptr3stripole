import QtQuick 2.0

Item {
    width: 300
    height: 150
    property string text: ""
    property int fontSize: 10

    Text {
        id: text1
        x: 98
        y: 68
        text: qsTr("Text")
        font.pixelSize: 12
    }

    MouseArea {
        id: mouseArea1
        x: 160
        y: 25
        width: 100
        height: 100
    }

}
