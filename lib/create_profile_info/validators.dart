String? Function(String?) requiredValidator(String message) {
  return (value) => (value == null || value.isEmpty) ? message : null;
}

String? Function(String?) numberValidator(String emptyMessage) {
  return (value) {
    if (value == null || value.isEmpty) return emptyMessage;
    if (double.tryParse(value) == null) return 'Please enter a valid number';
    return null;
  };
}
