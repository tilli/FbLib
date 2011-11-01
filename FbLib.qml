import QtQuick 1.0

Rectangle {

    width: 360
    height: 640
    id: root

    property alias accessToken: login.accessToken

    // --------------------------

    // Example login page usage
    //  - start() / stop() / running property to control login process
    //  - running turns to false when login process is over
    //  - accessToken property is available if login succeeds
    //  - interactive property determines when user needs to input something
    FbLogin {
        id: login
        anchors.fill: parent
        opacity: 0
        Component.onCompleted: running = true

        // Hide when there's access token available
        states: State {
            when: login.interactive
            PropertyChanges { target: login; opacity: 1 }
        }
        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    onAccessTokenChanged: console.debug("Got token: " + accessToken)

    // --------------------------

    // Example user list view with user image delegate
    FbUserListView {
        accessToken: root.accessToken
        anchors.fill: parent
        delegate: Row {
            height: 50
            width: parent.width
            spacing: 5
            Item { width: 5; height: parent.height }
            FbUserImage {
                id: userImage
                userId: model.id
                accessToken: root.accessToken
                anchors.verticalCenter: parent.verticalCenter
                height: 40
                width: 40
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                font.bold: true
                text: name
            }
        }
    }

    // --------------------------

}
