import QtQuick 2.15
import QtQuick.Controls 2.5

Item {
    width:256
    height:32
    anchors.top:parent
    anchors.horizontalCenter:parent.horizontalCenter
    y:32
    z:100
    TextField{
        anchors.fill:parent
        font.pixelSize: 32
        font.bold: true
        placeholderText: "Enter Command.."
    }
}
