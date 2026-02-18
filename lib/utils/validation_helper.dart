import 'package:bloc_architecure/core/constants/enums.dart';

class ValidationHelper {
  static String? validate(
    ValidationType type,
    String value, {
    String? newPassword,
  }) {
    switch (type) {
      case ValidationType.email:
        return _ValidationField.emailField(value);
      case ValidationType.userName:
        return _ValidationField.userNameField(value);
      case ValidationType.phone:
        return _ValidationField.phoneField(value);
      case ValidationType.password:
        return _ValidationField.passwordField(value);
      case ValidationType.confirmPassword:
        return _ValidationField.confirmPasswordField(
          value,
          newPassword: newPassword,
        );
      case ValidationType.currentPassword:
        return _ValidationField.currentPasswordField(value);
      case ValidationType.newPassword:
        return _ValidationField.newPasswordField(value);
      case ValidationType.companyName:
        return _ValidationField.companyNameField(value);
      case ValidationType.city:
        return _ValidationField.cityField(value);
      case ValidationType.pinCode:
        return _ValidationField.pincodeField(value);
      case ValidationType.address:
        return _ValidationField.addressField(value);
      case ValidationType.fullName:
        return _ValidationField.fullNameField(value);
      case ValidationType.country:
        return _ValidationField.countryField(value);
      case ValidationType.issueNote:
        return _ValidationField.issueNoteField(value);
    }
  }
}

class _ValidationField {
  static String? userNameField(String value) {
    if (value.trim().isEmpty) {
      return "Name can't be empty";
    }
    return null;
  }

  static String? emailField(String value) {
    final RegExp regex = RegExp(
      r"^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-z0-9-]+\.[a-z]{2,}$",
    );
    if (value.isEmpty) {
      return "Email can't be empty";
    } else if (!regex.hasMatch(value.trim())) {
      return 'Enter valid email';
    }
    return null;
  }

  static String? passwordField(String value) {
    value = value.trim();
    final RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$',
    );
    if (value.isEmpty) {
      return "Password can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must have A-Z, a-z, 0-9 and min. one special characters';
      } else if (value.length < 8) {
        return 'Min. 8 characters required';
      }
      return null;
    }
  }

  static String? confirmPasswordField(String value, {String? newPassword}) {
    value = value.trim();
    final RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$',
    );
    if (value.isEmpty) {
      return "Confirm password can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'Confirm password must have A-Z, a-z, 0-9 and min. one special characters';
      } else if (value.length < 8) {
        return 'Min. 8 characters required';
      } else if (value != newPassword) {
        return 'New Password and confirm password must be match';
      }
      return null;
    }
  }

  static String? newPasswordField(String value) {
    value = value.trim();
    final RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{0,}$',
    );
    if (value.isEmpty) {
      return "New password can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'New password must have A-Z, a-z, 0-9 and min. one special characters';
      } else if (value.length < 8) {
        return 'Min. 8 characters required';
      }
      return null;
    }
  }

  static String? currentPasswordField(String value) {
    value = value.trim();
    final RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{0,}$',
    );
    if (value.isEmpty) {
      return "Current password can't be empty";
    } else {
      if (!regex.hasMatch(value)) {
        return 'Current password must have A-Z, a-z, 0-9 and min. one special characters';
      } else if (value.length < 8) {
        return 'Min. 8 characters required';
      }
      return null;
    }
  }

  static String? phoneField(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return "Phone number can't be empty";
    } else if (value.length != 10) {
      return 'Please enter valid phone number';
    }
    return null;
  }

  static String? companyNameField(String value) {
    if (value.trim().isEmpty) {
      return "Company name can't be empty";
    }
    return null;
  }

  static String? cityField(String value) {
    if (value.trim().isEmpty) {
      return "City can't be empty";
    }
    return null;
  }

  static String? pincodeField(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return "Pincode can't be empty";
    } else if (value.length < 3) {
      return "Please enter valid pincode";
    }
    return null;
  }

  static String? addressField(String value) {
    if (value.trim().isEmpty) {
      return "Address can't be empty";
    }
    return null;
  }

  static String? fullNameField(String value) {
    if (value.trim().isEmpty) {
      return "Full name can't be empty";
    }
    return null;
  }

  static String? countryField(String value) {
    if (value.trim().isEmpty) {
      return "Country name can't be empty";
    }
    return null;
  }

  static String? issueNoteField(String value) {
    if (value.trim().isEmpty) {
      return "Issue name can't be empty";
    }
    return null;
  }
}
