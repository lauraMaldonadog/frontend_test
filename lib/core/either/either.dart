import 'package:freezed_annotation/freezed_annotation.dart';

part 'either.freezed.dart';

/// La clase `Either` es una clase genérica que representa un valor que puede ser de tipo `L` o de tipo `R`.
@freezed
abstract class Either<L, R> with _$Either<L, R> {
  factory Either.left(L value) = _Left;
  factory Either.right(R value) = _Right;
}
