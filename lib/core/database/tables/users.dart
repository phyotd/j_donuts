import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get phoneNumber => text().unique()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
