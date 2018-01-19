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
        searchShop(response);
        directionsDisplay.setDirections(response);
    });
}

function searchShop(response) {
    var request = [];
    var steps = response.routes[0].legs[0].steps;
    for(var i in steps) {
        request.push({latitude: steps[i].start_location.lat(), longitude: steps[i].start_location.lng() });
    }

    $.ajax({
        url: "/yelp/index",
        type: "GET",
        data: {steps: request}
    })
    .done(function(data){
    })
    .fail(function(){
    });
}


window.onload = initMap;

