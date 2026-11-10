
import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  RealColumn get price => real()();
  BoolColumn get isNew => boolean()();
  BoolColumn get isPopular =>
      boolean().withDefault(const Constant(false))();
  RealColumn get discountPercent => real().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get imageUrl => text()();

  @override
  Set<Column> get primaryKey => {id};
}
