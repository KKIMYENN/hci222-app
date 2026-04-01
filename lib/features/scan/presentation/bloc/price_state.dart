import 'package:equatable/equatable.dart';
import '../../data/models/region_stats.dart';

abstract class PriceState extends Equatable {
  const PriceState();
  @override
  List<Object?> get props => [];
}

class PriceInitial extends PriceState {
  const PriceInitial();
}

class PriceLoading extends PriceState {
  const PriceLoading();
}

class PriceLoaded extends PriceState {
  final RegionStats stats;
  final double? userPrice; // 사용자가 입력한 가격 (수직선용)
  const PriceLoaded({required this.stats, this.userPrice});
  @override
  List<Object?> get props => [stats, userPrice];

  PriceLoaded copyWith({double? userPrice}) =>
      PriceLoaded(stats: stats, userPrice: userPrice ?? this.userPrice);
}

class PriceSubmitting extends PriceState {
  final RegionStats stats;
  final double userPrice;
  const PriceSubmitting({required this.stats, required this.userPrice});
  @override
  List<Object?> get props => [stats, userPrice];
}

class PriceSubmitSuccess extends PriceState {
  const PriceSubmitSuccess();
}

class PriceError extends PriceState {
  final String message;
  const PriceError(this.message);
  @override
  List<Object?> get props => [message];
}
