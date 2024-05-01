// ignore_for_file: non_constant_identifier_names

class NotificationsHistory {
  final int? id;
  final String? user_id;
  final Object? metadata;
  final String? title;
  final String? body;
  final String? name;
  final String? image;
  final DateTime? createdAt;

  const NotificationsHistory(
      {this.id,
      this.user_id,
      this.image,
      this.metadata,
      this.createdAt,
      this.name,
      this.body,
      this.title});

  @override
  String toString() {
    return 'NotificationsHistory(id: $id, user_id: $user_id, image: $image, metadata: $metadata, name: $name, body: $body, title: $title, createdAt: $createdAt)';
  }
}
