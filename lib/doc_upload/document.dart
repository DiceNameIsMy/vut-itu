class Document {
  final String id;
  final String title;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;

  Document({
    required this.id,
    required this.title,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });
}
