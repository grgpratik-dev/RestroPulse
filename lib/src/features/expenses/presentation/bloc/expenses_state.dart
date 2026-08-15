part of 'expenses_bloc.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();  

  @override
  List<Object> get props => [];
}
class ExpensesInitial extends ExpensesState {}
