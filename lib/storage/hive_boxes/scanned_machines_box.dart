class ScannedMachineBox {
  static const String _boxName = 'scannedMachines';

  // static Future<Box<ScannedMachineRes>> _openBox() async {
  //   if (Hive.isBoxOpen(_boxName)) {
  //     return Hive.box<ScannedMachineRes>(_boxName);
  //   }
  //   return await Hive.openBox<ScannedMachineRes>(_boxName);
  // }
  //
  // static Future<List<ScannedMachineRes>> getMachines() async {
  //   final box = await _openBox();
  //   return box.values.toList();
  // }
  //
  // static Future<ScannedMachineRes?> getMachineDocuments({
  //   required String id,
  // }) async {
  //   final box = await _openBox();
  //   return box.values.toList().firstWhereOrNull(
  //         (machine) => machine.id == id,
  //   );
  // }
  //
  // static Future<void> addScannedMachine(ScannedMachineRes machine) async {
  //   final box = await _openBox();
  //   var machines = box.values.toList();
  //   int deleteIndex = machines.indexWhere((mac) => machine.id == mac.id);
  //   if (deleteIndex != -1) {
  //     await _deleteMachine(deleteIndex);
  //   }
  //   await box.add(machine);
  // }
  //
  // static Future<void> _deleteMachine(int index) async {
  //   final box = await _openBox();
  //   await box.deleteAt(index);
  // }
  //
  // static Future<void> deleteDetachedMachine(String machineId) async {
  //   final box = await _openBox();
  //   var machines = box.values.toList();
  //   for (var machine in machines) {
  //     if (machine.machineId == machineId) {
  //       await IOHelper.instance.deleteFileToDirectory(
  //         machine.machineImage
  //             ?.split('/')
  //             .lastOrNull ?? '',
  //         folderType: FolderType.documents,
  //       );
  //       await IOHelper.instance.deleteFileToDirectory(
  //         machine.fileUrl
  //             ?.split('/')
  //             .lastOrNull ?? '',
  //         folderType: FolderType.documents,
  //       );
  //       for (var document in machine.documents ?? []) {
  //         await IOHelper.instance.deleteFileToDirectory(
  //           document.documentLink
  //               ?.split('/')
  //               .lastOrNull ??
  //               document.externalLink
  //                   ?.split('/')
  //                   .lastOrNull ??
  //               '',
  //           folderType: FolderType.documents,
  //         );
  //       }
  //     }
  //   }
  //   machines.removeWhere((machine) => machine.machineId == machineId);
  //   await clearMachines();
  //   box.addAll(machines);
  // }
  //
  // static Future<void> removeMachine(String id) async {
  //   final box = await _openBox();
  //   var machines = box.values.toList();
  //   machines.removeWhere((machine) => machine.id == id);
  //   await clearMachines();
  //   box.addAll(machines);
  // }
  //
  // static Future<void> clearMachines() async {
  //   final box = await _openBox();
  //   await box.clear();
  // }
}
