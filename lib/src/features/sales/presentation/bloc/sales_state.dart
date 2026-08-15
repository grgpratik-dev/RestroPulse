part of 'sales_bloc.dart';

abstract class SalesState extends Equatable {
  const SalesState();  

  @override
  List<Object> get props => [];
}
class SalesInitial extends SalesState {}
