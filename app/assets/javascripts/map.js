var map;
var directionsDisplay
function initMap() {
    directionsDisplay = new google.maps.DirectionsRenderer;
    map = new google.maps.Map(document.getElementById('sample'), { // #sampleに地図を埋め込む
        center: { // 地図の中心を指定
            lat: 33.653487, // 緯度
            lng: 130.672685 // 経度
        },
        zoom: 13 // 地図のズームを指定
    });
    directionsDisplay.setMap( map );

    // ----
    
}

function search() {
    var start = document.getElementById('start').value;
    var end = document.getElementById('end').value;

    request = {
        origin: start,
        destination: end,
        travelMode: "DRIVING"
    }
    var directionService = new google.maps.DirectionsService();
    directionService.route(request, function(response, status) {
        directionsDisplay.setDirections(response)
    });
}

window.onload = initMap;

