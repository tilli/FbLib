import QtQuick 1.0
import QtWebKit 1.0

Item {

    // Access token from FB if login succeeds
    property string accessToken

    // Cannot bind directly to loginTimer.running, since timer will be
    // stopped in intermediate stage, while waiting for user feedback
    property bool running

    // Flag to determine required user interaction
    // This item can be kept invisible until this flag turns to true
    property bool interactive

    // Timeout for login
    property alias timeout: loginTimer.interval

    function start() {
        if (!running) {
            privObj.start();
        }
    }

    function stop() {
        if (running) {
            privObj.stop();
        }
    }

    onRunningChanged: if (running) { privObj.start(); } else { privObj.stop(); }

    id: rootItem

    QtObject {
        id: privObj
        function start() {
            webView.url = "https://www.facebook.com/dialog/oauth?client_id=128963147209977&redirect_uri=http://www.facebook.com/connect/login_success.html&response_type=token&display=popup";
            rootItem.running = true;
            loginTimer.start();
        }
        function stop() {
            webView.url = "";
            rootItem.running = false;
            rootItem.interactive = false;
            loginTimer.stop();
        }
    }

    WebView {

        id: webView
        anchors.fill: parent

        onLoadFinished: {
            console.debug("Auth response: " + url);
            var processed = false;
            var list = url.toString().split("#");
            if (list[0] == "http://www.facebook.com/connect/login_success.html") {
                // Change access token before stop, so client can observer running property
                list = list[1].split("&");
                rootItem.accessToken = list[0];
                rootItem.stop();
                processed = true;
            } else {
                list = url.toString().split("?");
                if (list.length >= 2) {
                    list = list[1].split("&");
                    for (var elem in list) {
                        var tags = list[elem].split("=");
                        if (tags[0] == "error") {
                            rootItem.stop();
                            processed = true;
                            break;
                        }
                    }
                }
            }

            // Waiting for user, so stop timer
            if (!processed) {
                loginTimer.stop();
                rootItem.interactive = true
            }
        }

        Timer {
            id: loginTimer
            interval: 30000
            repeat: false
            onTriggered: {
                rootItem.stop();
            }
        }

    }
}
