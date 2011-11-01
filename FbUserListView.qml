import QtQuick 1.0
import "js/FbLoader.js" as FbLoader

ListView {

    property string accessToken

    ListModel {
        id: userModel
    }

    model: userModel

    onAccessTokenChanged: if (accessToken) { FbLoader.loadUserModel(userModel, accessToken); } else { userModel.clear(); }

}
