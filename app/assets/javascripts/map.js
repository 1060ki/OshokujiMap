var map;
var directionsDisplay;
var markers = [];
var infowindow = new google.maps.InfoWindow();

var $infoWindowDOM = $('<div class="g-infoWindow"><img src=""><div class="info"><div class="name"><a target="_blank"></a></div><div class="address"></div><div class="tel"></div></div>')

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
    google.maps.event.addListener(map, "click", function() {infowindow.close();});
    
}

function search() {
    markers.forEach(function(marker) {
        marker.setMap(null);
    });

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
    var steps = response.routes[0].overview_path;
    for(var i in steps) {
        request.push({latitude: steps[i].lat(), longitude: steps[i].lng()});
    }

    $.ajax({
        url: "/yelp/steps",
        type: "POST",
        data: {steps: request}
    })
    .done(function(data){
        data.forEach(function(shop) {
            var pos = {lat: shop.coordinates.latitude, lng: shop.coordinates.longitude};
            addMarker(pos, shop);
           // info(shop.id);
        });
    })
    .fail(function(){
    });
}

function addMarker(position, shop){
    //var image = '/icon.png';
    var marker = new google.maps.Marker({
        position: position,
        title: shop.id,
        icon: {
            url: "/icon.png" ,
            scaledSize: new google.maps.Size( 50, 50 ) ,
        }
    });

    google.maps.event.addListener(marker, 'click', function (event) {
        $infoWindowDOM.find("img").attr("src", shop.image_url);
        $infoWindowDOM.find(".name a").text(shop.name);
        $infoWindowDOM.find(".name a").attr("href", shop.url);
        $infoWindowDOM.find(".address").text(shop.location.display_address);
        $infoWindowDOM.find(".tel").text(shop.display_phone);
        
        infowindow.setContent($infoWindowDOM.prop("outerHTML"));
        // infowindow.setContent("<div><img src='" + shop.image_url + "'></div><div>" + shop.id + "</div>");
        infowindow.open(marker.getMap(), marker);
      });

    markers.push(marker);
    
    // To add the marker to the map, call setMap();
    marker.setMap(map);
    
}




window.onload = initMap;

