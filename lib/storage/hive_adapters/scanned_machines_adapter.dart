// import 'package:hive/hive.dart';
//
// import '../../data/models/res_models/scanned_machine_res.dart';
//
// class ScannedMachinesAdapter extends TypeAdapter<ScannedMachineRes> {
//   @override
//   final int typeId = 1; // must unique
//
//   @override
//   ScannedMachineRes read(BinaryReader reader) {
//     return ScannedMachineRes.fromJson(reader.readMap());
//   }
//
//   @override
//   void write(BinaryWriter writer, ScannedMachineRes obj) {
//     writer.writeMap(obj.toJson());
//   }
// }
