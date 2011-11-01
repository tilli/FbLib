.pragma library

Qt.include("JsonLoader.js")

// Fetch user model from Graph API and append each element to model
function loadUserModel(model, accessToken) {
    // Temporary list for received elements
    var list = [];

    // Load data from FB
    loadJson("https://graph.facebook.com/me/friends?" + accessToken, "/data",

             // For each element, push it into the temporary array
             function(element) { list.push(element); },

             // After everything has been loaded, sort the array alphabetically
             // and move data to ListModel
             function() {
                 list.sort(function(a,b) { return a.name.localeCompare(b.name); });
                 for (var index in list) {
                     model.append(list[index]);
                 }
             });
}

function loadUserStatus(user, hookFunction) {
    var xhr = new XMLHttpRequest;
    var url = "https://graph.facebook.com/" + user + "/posts?" + accessToken;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            // Parse JSON data from response
            var response = JSON.parse(xhr.responseText);
            var jpath = new JPath(response);
            var list = jpath.query("/data");
            for (var index in list) {
                var element = list[index];
                if (element.type == "status") {
                    hookFunction(element.message);
                }
            }
        }
    }
    xhr.send();
}

