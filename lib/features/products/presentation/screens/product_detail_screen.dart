import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:j_donuts/app/theme/app_colors.dart';
import 'package:j_donuts/features/products/domain/entities/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String heroTag;

  const ProductDetailScreen({super.key, required this.product, required this.heroTag});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  static final NumberFormat _priceFormatter = NumberFormat('#,##0');

  String _formatPrice(double price) {
    return '${_priceFormatter.format(price)} MMK';
  }

  double get _totalPrice => widget.product.price * _quantity;

  void _decreaseQuantity() {
    if (_quantity <= 1) return;

    setState(() {
      _quantity--;
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} x $_quantity added to cart'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(backgroundColor: AppColors.surface, elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product, widget.heroTag),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Code: ${product.code}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (product.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    _formatPrice(product.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "What's this?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _buildQuantitySelector(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddToCartButton(),
    );
  }

  Widget _buildProductImage(Product product, String heroTag) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          color: AppColors.primaryLight,
          child: Hero(
            tag: heroTag,
            child: Image.asset(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.bakery_dining,
                    size: 100,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ),
        if (product.isNew)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1 ? _decreaseQuantity : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
              iconSize: 28,
            ),
            Text(
              '$_quantity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _increaseQuantity,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
              iconSize: 28,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatPrice(_totalPrice),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
