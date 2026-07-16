/// Enum representing the two user roles in the application.
///
/// - [admin]: Administrator — manages flight data, weather data, and users.
/// - [amc]: Apron Movement Control officer — runs predictions, views results, accesses reports.
enum UserRoleType {
  admin,
  amc;

  /// Parse a role string from the server into a [UserRoleType].
  /// Defaults to [amc] if the string is unrecognized.
  static UserRoleType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'admin':
        return UserRoleType.admin;
      case 'amc':
      default:
        return UserRoleType.amc;
    }
  }

  /// Display-friendly label for the role.
  String get displayName {
    switch (this) {
      case UserRoleType.admin:
        return 'Administrator';
      case UserRoleType.amc:
        return 'Petugas AMC';
    }
  }
}
