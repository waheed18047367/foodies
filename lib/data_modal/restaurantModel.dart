class RestaurantModel {
  String image,title,location,ratting,id,price;
  double lat,long;
  bool near;
  RestaurantModel({
    this.near,
    this.lat,
    this.long,
    this.image,
    this.location,
    this.title,
    this.price,
    this.ratting,
    this.id
  });
}

