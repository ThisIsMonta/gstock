class Member {
  int? id;
  final String name;
  final String phoneNumber1;
  final String phoneNumber2;

  Member({
    this.id,
    required this.name,
    required this.phoneNumber1,
    required this.phoneNumber2,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "phoneNumber1": this.phoneNumber1,
      "phoneNumber2": this.phoneNumber2,
    };
  }

  Member copy(
          {int? id,
          String? name,
          String? phoneNumber1,
          String? phoneNumber2}) =>
      Member(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber1: phoneNumber1 ?? this.phoneNumber1,
        phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      );

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json["id"],
      name: json["name"],
      phoneNumber1: json["phoneNumber1"],
      phoneNumber2: json["phoneNumber2"],
    );
  }

  @override
  String toString() {
    return 'Member{name: $name, phoneNumber1: $phoneNumber1, phoneNumber2: $phoneNumber2}';
  }
}
