		var map = null;
		var geocoder = null;
		var curLat = null;
		var curLong = null;
		var curMarkerOverlay = null;
		var userOverlays = [];
		var temperatureData = [
			{'lat': 59.956697, 'lng':30.311075, 'value': '23'},
			{'lat': 59.957697, 'lng':30.311185, 'value': '24'},
			{'lat': 59.958697, 'lng':30.311295, 'value': '25'},
		];

		var eventListeners = [];

		function initialize() {
			if (GBrowserIsCompatible()) {
				map = new GMap2(document.getElementById("map"));
				map.setCenter(new GLatLng(59.956697,30.311075), 15);
				map.setUIToDefault();
				GEvent.addListener(map, 'addoverlay',
					function (overlay) {
						userOverlays.push(overlay);
					}
				);
				geocoder = new GClientGeocoder();
                                if (window.show_temp_data)
                                    showTemperatureData(temperatureData);
                                else
                                    setUserLocation('geo-lat','geo-long');
			}
		}


		function setUserLocation(textLat, textLng, count) {
			var btn = document.getElementById('setlocation_btn');
			if (map && map.isLoaded()) {
				if (!eventListeners['setLocation'])  {
					eventListeners['setLocation'] = GEvent.addListener(map, 'click', 
						function (overlay, latlng) {
							var lat = latlng.lat();
							var lng = latlng.lng();
							var lat_field = document.getElementById(textLat);
							var lng_field = document.getElementById(textLng);
							if (lat_field) { lat_field.value = lat; };
							if (lng_field) { lng_field.value = lng; };
							clearUserOverlays();
							map.addOverlay(new GMarker(new GLatLng(lat,lng)));
						}
					);
					btn.value = "Stop!";
				}
				if (!eventListeners['stopSetLocation']) {
					eventListeners['stopSetLocation'] = GEvent.addDomListener(btn, 'click', 
						function() {
							GEvent.removeListener(eventListeners['setLocation']);
							eventListeners['setLocation'] = null;
							GEvent.removeListener(eventListeners['stopSetLocation']);
							eventListeners['stopSetLocation'] = null;
							btn.value = "Go!";
						}
					);
				}
			}
		}
		
		function searchAddress(address) {
			if (!address) {
				address = document.getElementById('search_field').value;
			}
			if (geocoder) {
				geocoder.getLocations(address, showPlaces);
			}
		}
		
		function showPlaces(places) {
			if (!places || (places.Status.code != 200)) {
				alert('Nothing Found');
			} else {
				var place = places.Placemark[0];
				var point = new GLatLng(place.Point.coordinates[1], place.Point.coordinates[0]);
				map.setCenter(point, 10);
				map.addOverlay(new GMarker(point));
			}

		}
		
		function showInfoWindow() {
			if (map && map.isLoaded) {
			
			}
		}
		
		function clearUserOverlays() {
			for (var i = 0; i < userOverlays.length; ++i) {
				map.removeOverlay(userOverlays[i]);
			}
		}
		
		function showTemperatureData(temperatureData) {
			if (map && map.isLoaded) {
				for (var i=0; i < temperatureData.length; ++i) {
					var data = temperatureData[i];
					var point = new GLatLng(data['lat'], data['lng']);
					var marker = new GMarker(point, {title : data['value']});
					map.addOverlay(marker);
					marker.bindInfoWindowHtml('Temperature: '+data['value']);
					
				}
			}
		}
