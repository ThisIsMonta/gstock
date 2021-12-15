class Loan {
  int? id;
  final int memberId;
  final int componentId;
  final int quantity;
  final DateTime returnDate;
  final String status;
  final String state;

  Loan({
    this.id,
    required this.memberId,
    required this.componentId,
    required this.quantity,
    required this.returnDate,
    required this.status,
    required this.state,
  });

  Loan copy(
          {int? id,
          int? memberId,
          int? componentId,
          int? quantity,
          DateTime? returnDate,
          String? status,
          String? state}) =>
      Loan(
          id: id ?? this.id,
          memberId: memberId ?? this.memberId,
          componentId: componentId ?? this.componentId,
          quantity: quantity ?? this.quantity,
          returnDate: returnDate ?? this.returnDate,
          status: status ?? this.status,
          state: state ?? this.state);

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json["id"],
      memberId: json["memberId"],
      componentId: json["componentId"],
      quantity: json["quantity"],
      returnDate: DateTime.parse(json["returnDate"] as String),
      status: json["status"],
      state: json["state"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "memberId": this.memberId,
      "componentId": this.componentId,
      "quantity": this.quantity,
      "returnDate": this.returnDate.toIso8601String(),
      "status": this.status,
      "state": this.state,
    };
  }

  @override
  String toString() {
    return 'Loan{id: $id, memberId: $memberId, componentId: $componentId, quantity: $quantity, returnDate: $returnDate, status: $status, state: $state}';
  }
}
