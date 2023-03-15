import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB
import org.mauikit.texteditor 1.0 as TE
import QtQuick.Controls 1.4 as QQC1
import "components" as Components
import Qt.labs.folderlistmodel 2.4
import QtQml.Models 2.1

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Kide")

    property string activeDirectory

    FB.FileDialog{
        id:_folderDialog
        settings.onlyDirs: true
    }

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent

        sideBarContent:  Maui.Page
        {
            anchors.fill: parent
            Maui.Theme.colorSet: Maui.Theme.Window

            headBar.leftContent: [
                Maui.ToolButtonMenu
                {
                    icon.name: "application-menu"


                    MenuItem{
                        text: i18n("New")
                        icon.name: "file"
                    }
                    MenuItem{
                        id: _openFolderMenuItem
                        text: i18n("Open")
                        icon.name: "folder"
                        onTriggered: {
                            _folderDialog.open()
                            _folderDialog.callback = function(urls){
                                if (urls.length > 0){
                                    console.log("Setting active directory")
                                    root.activeDirectory = urls[0]
                                }
                            }
                        }
                    }
                    Maui.Separator{

                    }
                    MenuItem
                    {
                        text: i18n("Settings")
                        icon.name: "settings-configure"
                    }

                    MenuItem
                    {
                        text: i18n("About")
                        icon.name: "documentinfo"
                        onTriggered: root.about()
                    }
                }
            ]

                ColumnLayout{
                    anchors.left:parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top

                    visible:root.activeDirectory == ""

                    Label{
                        Layout.alignment: Qt.AlignHCenter

                        text:"No project is opened"
                    }
                    Button{
                        Layout.alignment: Qt.AlignHCenter

                        text:"Open"
                        icon.name:"folder"
                        onPressed: _openFolderMenuItem.onTriggered()
                    }

                }

                ListView{
                    visible: root.activeDirectory != ""
                    id:folderHierarchy
                    anchors.fill:parent
                    model:dirModel

                    onCurrentItemChanged: {
                        console.log("Selected")
                        var sel = model.get(0,0)
                        if (sel != undefined){
                            console.log(model.get(0,0).name + ' selected')
                        }
                    }
                    highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                    focus: true
                    DelegateModel{
                        id: dirDelegateModel
                        model: FolderListModel {
                            id: dirModel
                            folder: root.activeDirectory
                            showDirsFirst: true
                        }
                    }

                      delegate: Text {
                        text: fileName

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    folderHierarchy.currentIndex = index
                                }
                            }
                        }


                }

        }

        Maui.Page
        {

            anchors.fill: parent
            showCSDControls: true
            headBar.background: null
            headBar.leftContent: [
                ToolButton
                {
                    icon.name: "sidebar-collapse"
                    onClicked: _sideBarView.sideBar.toggle()
                    checked: _sideBarView.sideBar.visible
                }
            ]
            headBar.rightContent:[
                TextField{

                }

            ]
                    Keys.enabled: true
                    Keys.onPressed:(event)=>
                    {
                        console.log(event)
                        if (event.text === "{"){

                            _editor.text += "}"
                            event.accepted = true
                        }
                    }

                TE.TextEditor{
                    id: _editor
                    anchors.fill: parent
                    document.enableSyntaxHighlighting: true
                    showLineNumbers:true
                    body.font.family: Qt.font({family: "Noto Sans Mono", pointSize: Maui.Style.fontSizes.default})
                    document.tabSpace:  ((4+1) * body.font.pointSize) / 2


                    Keys.enabled: true
                    Keys.onPressed:(event)=>
                    {
                        console.log(event)
                        if (event.text === "{"){

                            _editor.text += "}"
                            event.accepted = true
                        }
                    }
                }

            }
        }

}
