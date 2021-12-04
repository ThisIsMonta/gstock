import 'package:gstock/classes/Component.dart';
import 'package:gstock/classes/Member.dart';

class Loan{
  final Member member;
  final Component component;
  final DateTime loanDate;
  final String status;
  final String state;

  Loan({
    required this.member,
    required this.component,
    required this.loanDate,
    required this.status,
    required this.state,
  });
}