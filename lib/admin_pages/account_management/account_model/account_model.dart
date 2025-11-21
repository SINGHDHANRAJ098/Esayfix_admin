// lib/account_model/account_model.dart

class AdminProfile {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;

  const AdminProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  AdminProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return AdminProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  factory AdminProfile.fromMap(Map<String, dynamic> map) {
    return AdminProfile(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
    );
  }
}

class Policy {
  final String id;
  final String title;
  final String description;
  final String content;
  final DateTime lastUpdated;
  final String version;

  const Policy({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.lastUpdated,
    required this.version,
  });

  Policy copyWith({
    String? title,
    String? description,
    String? content,
    DateTime? lastUpdated,
    String? version,
  }) {
    return Policy(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'version': version,
    };
  }

  factory Policy.fromMap(Map<String, dynamic> map) {
    return Policy(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']),
      version: map['version'] ?? '',
    );
  }
}

class SupportContact {
  final String phone;
  final String email;
  final String workingHours;

  const SupportContact({
    required this.phone,
    required this.email,
    required this.workingHours,
  });

  SupportContact copyWith({
    String? phone,
    String? email,
    String? workingHours,
  }) {
    return SupportContact(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      workingHours: workingHours ?? this.workingHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'workingHours': workingHours,
    };
  }

  factory SupportContact.fromMap(Map<String, dynamic> map) {
    return SupportContact(
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      workingHours: map['workingHours'] ?? '',
    );
  }
}

class SupportTicket {
  final String id;
  final String subject;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  SupportTicket copyWith({
    String? id,
    String? subject,
    String? description,
    String? priority,
    String? status,
    DateTime? createdAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'priority': priority,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    return SupportTicket(
      id: map['id'] ?? '',
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Medium',
      status: map['status'] ?? 'Open',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
