enum UserStatus {
  enabled,
  disabled,
}

enum UserScope {
  root,
  admin,
  user,
}

class MinimalUser {
  final int id;
  final String username;
  final String scope;
  final String status;

  MinimalUser({
    required this.id,
    required this.username,
    required this.scope,
    required this.status,
  });

  static UserStatus fromStringStatus(String status) {
    switch (status) {
      case "Enabled":
        return UserStatus.enabled;
      case "Disabled":
        return UserStatus.disabled;
      default:
        throw const FormatException("Invalid status string");
    }
  }

  static UserScope fromStringScope(String scope) {
    switch (scope) {
      case "root":
        return UserScope.root;
      case "admin":
        return UserScope.admin;
      case "user":
        return UserScope.user;
      default:
        throw const FormatException("Invalid scope string");
    }
  }

  factory MinimalUser.fromJson(Map<String, dynamic> json) {
    return MinimalUser(
      id: json['id'],
      username: json['username'],
      scope: json['scope'],
      status: json['status'],
    );
  }
}