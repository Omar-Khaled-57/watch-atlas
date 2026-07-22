enum Gender {
  male,
  female,
  ratherNotSay;

  String get dbValue => name;

  static Gender? fromDbValue(String? value) {
    return switch (value) {
      'male' => Gender.male,
      'female' => Gender.female,
      'ratherNotSay' => Gender.ratherNotSay,
      _ => null,
    };
  }
}
