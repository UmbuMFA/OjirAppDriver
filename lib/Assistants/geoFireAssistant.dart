import 'package:driver_app/Models/nearbyAvailableOrder.dart';

class GeoFireAssistant {
  static List<NearbyAvailableOrder> nearByAvailableOrderList = [];

  static void removeDriverFromList(String id) {
    int index =
        nearByAvailableOrderList.indexWhere((element) => element.id == id);
    nearByAvailableOrderList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearbyAvailableOrder driver) {
    int index = nearByAvailableOrderList
        .indexWhere((element) => element.id == driver.id);

    nearByAvailableOrderList[index].latitude = driver.latitude;
    nearByAvailableOrderList[index].longitude = driver.longitude;
  }
}
