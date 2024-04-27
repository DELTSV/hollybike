typedef FormFields = Map<String, FormFieldConfig>;

class FormFieldConfig {
  final String? Function(String?) validator;
  final bool isSecured;
  final bool hasControlField;

  FormFieldConfig({
    required this.validator,
    this.isSecured = false,
    this.hasControlField = false,
  });
}
