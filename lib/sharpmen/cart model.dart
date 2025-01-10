class Cart {
  int? id;
  String productId;
  String productName;
  double initialPrice;
  double productPrice;
  int quantity;
  String image;

  Cart({
    this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'image': image,
    };
  }

  Cart.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        productId = map['productId'],
        productName = map['productName'],
        initialPrice = map['initialPrice'],
        productPrice = map['productPrice'],
        quantity = map['quantity'],
        image = map['image'];
}
