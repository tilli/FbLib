import QtQuick 1.0

Image {
    property string accessToken
    property string userId

    // TODO: Local cache
    source: accessToken === "" ? "images/nopic.gif" : "https://graph.facebook.com/" + userId + "/picture?" + accessToken
    fillMode: Image.PreserveAspectFit
}
