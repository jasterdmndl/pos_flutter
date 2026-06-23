enum DiscountType {
  none,
  pwd,
  senior,
}

extension DiscountTypeX on DiscountType {
  double get rate {
    switch (this) {
      case DiscountType.pwd:
      case DiscountType.senior:
        return 0.20;
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
      case DiscountType.none:
        return "No Discount";
    }
  }
}