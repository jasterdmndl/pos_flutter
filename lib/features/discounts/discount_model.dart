enum DiscountType {
  none,
  pwd,
  senior,
  student,
}

extension DiscountTypeX on DiscountType {
  double get rate {
    switch (this) {
      case DiscountType.pwd:
      case DiscountType.senior:
        return 0.20;
      case DiscountType.student:
        return 0.10;
      case DiscountType.none:
        return 0.0;
    }
  }

  String get label {
    switch (this) {
      case DiscountType.pwd:
        return "PWD (20%)";
      case DiscountType.senior:
        return "Senior (20%)";
      case DiscountType.student:
        return "Student (10%)";
      case DiscountType.none:
        return "No Discount";
    }
  }

  /// In the Philippines, SC and PWD are VAT exempt, 
  /// but Students typically are NOT VAT exempt (only discounted).
  bool get isVatExempt {
    switch (this) {
      case DiscountType.pwd:
      case DiscountType.senior:
        return true;
      default:
        return false;
    }
  }
}
