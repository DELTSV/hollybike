typedef FormFields = Map<String, FormFieldConfig>;

class FormFieldConfig {
  final String label;
  final String? Function(String?) validator;
  final bool isSecured;
  final bool hasControlField;

  FormFieldConfig({
    required this.label,
    required this.validator,
    this.isSecured = false,
    this.hasControlField = false,
  });
}
