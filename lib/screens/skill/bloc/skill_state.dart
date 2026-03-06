part of 'skill_bloc.dart';

sealed class SkillState extends Equatable {
  const SkillState();
  
  @override
  List<Object> get props => [];
}

final class SkillInitial extends SkillState {}
