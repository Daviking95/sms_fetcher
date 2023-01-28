//
//
// _getCurrency() async {
//   StreamSubscription<Position> positionStream =
//   Geolocator.getPositionStream().listen(
//         (Position position) async {
//       // Use the position to determine the user's country
//       List<Placemark> placemark = await placemarkFromCoordinates(
//           position.latitude, position.longitude);
//       String countryCode = placemark[0].isoCountryCode ?? "";
//       // Use the country code to format the currency
//       var formatter = new NumberFormat.currency(locale: 'en_$countryCode');
//       var priceInUserCountry = formatter.format(12345);
//       print(priceInUserCountry);
//     },
//   );
// }
//
// Future<void> _getGeoLocationPosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     await Geolocator.openLocationSettings();
//     return Future.error('Location services are disabled.');
//   }
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   location = await Geolocator.getCurrentPosition();
//
//   log(("formatteCountryCode $location"));
// }
//
// Future<void> getCurrencyFromLatLong() async {
//   await _getGeoLocationPosition();
//
//   List<Placemark> placemarks =
//   await placemarkFromCoordinates(location!.latitude, location!.longitude);
//   print(placemarks);
//   Placemark place = placemarks[0];
//   String countryCode = place.isoCountryCode ?? "";
//   var formatteCountryCode = NumberFormat.currency(locale: 'en_$countryCode');
//
//   log(("formatteCountryCode $formatteCountryCode"));
//   _currency = formatteCountryCode.currencyName ?? "N";
//   // return formatteCountryCode.currencyName;
// }
