import 'package:j_donuts/features/products/data/models/product_model.dart';

class ProductMockData {
  ProductMockData._();

  static const List<ProductModel> products = [
    ProductModel(
      id: 'p_coconut',
      code: 'JD022123',
      price: 3200,
      isNew: true,
      isPopular: true,
      discountPercent: null,
      name: 'Coconut Donut',
      description: 'Enjoy our scrumptious coconut donut '
          'topped with delicious coconut flakes.',
      imageUrl: 'assets/images/donuts/coconut.jpeg',
    ),
    ProductModel(
      id: 'p_chocolate',
      code: 'JD022124',
      price: 3500,
      isNew: false,
      isPopular: true,
      discountPercent: 10,
      name: 'Chocolate Donut',
      description: 'Soft and fluffy donut covered with '
          'rich chocolate glaze.',
      imageUrl: 'assets/images/donuts/chocolate.jpeg',
    ),
    ProductModel(
      id: 'p_strawberry',
      code: 'JD022125',
      price: 3500,
      isNew: true,
      isPopular: false,
      discountPercent: null,
      name: 'Strawberry Donut',
      description: 'Delicious donut with sweet strawberry '
          'icing and colorful toppings.',
      imageUrl: 'assets/images/donuts/strawberry.jpeg',
    ),
    ProductModel(
      id: 'p_matcha',
      code: 'JD022126',
      price: 3800,
      isNew: false,
      isPopular: false,
      discountPercent: 15,
      name: 'Matcha Donut',
      description: 'A soft donut topped with Japanese '
          'matcha-flavored glaze.',
      imageUrl: 'assets/images/donuts/matcha.jpeg',
    ),
    ProductModel(
      id: 'p_vanilla',
      code: 'JD022127',
      price: 3000,
      isNew: false,
      isPopular: false,
      discountPercent: null,
      name: 'Vanilla Donut',
      description: 'Classic soft donut with smooth '
          'and sweet vanilla glaze.',
      imageUrl: 'assets/images/donuts/vanilla.jpeg',
    ),
    ProductModel(
      id: 'p_oreo',
      code: 'JD022128',
      price: 4000,
      isNew: true,
      isPopular: true,
      discountPercent: 10,
      name: 'Oreo Cream Donut',
      description: 'Cream-filled donut topped with '
          'crushed chocolate cookies.',
      imageUrl: 'assets/images/donuts/oreo.jpeg',
    ),
    ProductModel(
      id: 'p_boston',
      code: 'JD022129',
      price: 4200,
      isNew: false,
      isPopular: true,
      discountPercent: null,
      name: 'Boston Cream Donut',
      description: 'Classic donut filled with smooth '
          'vanilla custard and chocolate topping.',
      imageUrl: 'assets/images/donuts/boston.jpeg',
    ),
    ProductModel(
      id: 'p_caramel',
      code: 'JD022130',
      price: 3800,
      isNew: false,
      isPopular: false,
      discountPercent: 20,
      name: 'Caramel Donut',
      description: 'Fresh donut covered with sweet '
          'caramel sauce.',
      imageUrl: 'assets/images/donuts/caramel.jpeg',
    ),
    ProductModel(
      id: 'p_blueberry',
      code: 'JD022131',
      price: 3600,
      isNew: true,
      isPopular: false,
      discountPercent: null,
      name: 'Blueberry Donut',
      description: 'Soft donut with fruity blueberry '
          'glaze and delicious toppings.',
      imageUrl: 'assets/images/donuts/blueberry.jpeg',
    ),
    ProductModel(
      id: 'p_sugar',
      code: 'JD022132',
      price: 2800,
      isNew: false,
      isPopular: false,
      discountPercent: null,
      name: 'Sugar Donut',
      description: 'Simple and fluffy donut coated '
          'with fine powdered sugar.',
      imageUrl: 'assets/images/donuts/sugar.jpeg',
    ),
  ];
}