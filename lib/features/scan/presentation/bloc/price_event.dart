import 'package:equatable/equatable.dart';

abstract class PriceEvent extends Equatable {
  const PriceEvent();
  @override
  List<Object?> get props => [];
}

class PriceStatsRequested extends PriceEvent {
  final String productId;
  final double lat;
  final double lon;
  const PriceStatsRequested({
    required this.productId,
    required this.lat,
    required this.lon,
  });
  @override
  List<Object?> get props => [productId, lat, lon];
}

class PriceSubmitted extends PriceEvent {
  final String productId;
  final double price;
  final String unit;
  final String userId;
  const PriceSubmitted({
    required this.productId,
    required this.price,
    required this.unit,
    required this.userId,
  });
  @override
  List<Object?> get props => [productId, price, unit, userId];
}
