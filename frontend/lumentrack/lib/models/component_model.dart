class Component {
  final int? componentId;
  final int sampleId;
  final String componentName;
  final String componentType;
  final String componentDescription;
  final String photoUrl;
  final String photoId;
  final bool isExternal;
  final DateTime deliveryDate;
  final int materialId;
  final String? statusResume;
  final String ulaLightEmployee;
  final int taskId;

  Component({
    this.componentId,
    required this.sampleId,
    required this.componentName,
    required this.componentType,
    required this.componentDescription,
    required this.photoUrl,
    required this.photoId,
    required this.isExternal,
    required this.deliveryDate,
    required this.materialId,
    this.statusResume,
    required this.ulaLightEmployee,
    required this.taskId,
  });
}
