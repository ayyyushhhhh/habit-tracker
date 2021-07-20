import 'package:hive/hive.dart';
import 'package:time_table/models/time_blocker/time_block_model.dart';

class TaskBox {
  static Box<List<TimeBlockModel>> getTaskBox() {
    return Hive.box<List<TimeBlockModel>>("Tasks");
  }
}
