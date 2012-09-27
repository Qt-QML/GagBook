import QtQuick 1.1
import com.nokia.meego 1.0
import "infinigag.js" as Server
import "MainPage.js" as Script

Page {
    id: mainPage

    property Item sectionDialog: null
    property int nextPageId: 0

    tools: ToolBarLayout{
        ToolIcon{
            platformIconId: "toolbar-back-dimmed"
            enabled: false
        }
        ToolIcon{
            platformIconId: "toolbar-refresh" + (enabled ? "" : "-dimmed")
            enabled: !pageHeader.busy
            onClicked: Script.refresh()
        }
        ToolIcon{
            platformIconId: "toolbar-new-message" + (enabled ? "" : "-dimmed")
            enabled: gagListView.count > 0
            onClicked: {
                var prop = {gagURL: gagListView.model.get(gagListView.currentIndex).url}
                pageStack.push(Qt.resolvedUrl("CommentsPage.qml"), prop)
            }
        }
        ToolIcon{
            platformIconId: "toolbar-view-menu"
            onClicked: mainMenu.open()
        }
    }

    Menu{
        id: mainMenu

        MenuLayout{
            MenuItem{
                text: "Open in web browser"
                enabled: gagListView.count > 0
                onClicked: Qt.openUrlExternally(gagListView.model.get(gagListView.currentIndex).url)
            }
            MenuItem{
                text: "Share"
                enabled: gagListView.count > 0
                onClicked: shareUI.share(gagListView.model.get(gagListView.currentIndex).title,
                                         gagListView.model.get(gagListView.currentIndex).url)
            }
            MenuItem{
                text: "Settings"
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem{
                text: "About GagBook"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }

    ListView{
        id: gagListView
        anchors{ top: pageHeader.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
        model: ListModel{}
        boundsBehavior: Flickable.DragOverBounds
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        delegate: GagDelegate{}
        interactive: count === 0 || !currentItem.allowDelegateFlicking || moving
        onAtXEndChanged: if(atXEnd && count > 0 && !pageHeader.busy) Script.refresh(false)
    }

    PageHeader{
        id: pageHeader
        text: {
            switch(settings.selectedSection){
            case 0: return "Hot"
            case 1: return "Trending"
            case 2: return "Vote"
            default: return ""
            }
        }
        comboboxVisible: true
        onClicked: Script.openSectionDialog()
    }

    Component.onCompleted: Script.refresh()
}