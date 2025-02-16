import 'package:flutter/foundation.dart';

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}

class Product {
  final String id;
  final String title;
  final double price;
  final String image;
  final String description;
  final Rating rating;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'rating': {
        'rate': rating.rate,
        'count': rating.count,
      },
      'category': category,
    };
  }


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      rating: Rating.fromJson(json['rating']),
      category: json['category'] ?? '',
    );
  }
}