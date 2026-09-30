part of 'labels_bloc.dart';

sealed class LabelsEvent extends Equatable {
  const LabelsEvent();

  @override
  List<Object?> get props => [];
}

class LabelsStarted extends LabelsEvent {
  const LabelsStarted();
}

class LabelsTabChanged extends LabelsEvent {
  const LabelsTabChanged(this.tab);
  final LabelsTab tab;
  @override
  List<Object?> get props => [tab];
}

class LabelsSearchChanged extends LabelsEvent {
  const LabelsSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class LabelsTemplateSelected extends LabelsEvent {
  const LabelsTemplateSelected(this.templateId, {this.defaultCopies});
  final int templateId;
  final int? defaultCopies;
  @override
  List<Object?> get props => [templateId, defaultCopies];
}

class LabelsStoreTypeFilterChanged extends LabelsEvent {
  const LabelsStoreTypeFilterChanged(this.storeType);
  final LabelStoreType? storeType;
  @override
  List<Object?> get props => [storeType];
}

class LabelsBulkModeChanged extends LabelsEvent {
  const LabelsBulkModeChanged(this.mode);
  final LabelBulkMode mode;
  @override
  List<Object?> get props => [mode];
}

class LabelsCategoryChanged extends LabelsEvent {
  const LabelsCategoryChanged(this.category);
  final String? category;
  @override
  List<Object?> get props => [category];
}

class LabelsProductToggled extends LabelsEvent {
  const LabelsProductToggled(this.productId);
  final int productId;
  @override
  List<Object?> get props => [productId];
}

class LabelsSelectAllVisible extends LabelsEvent {
  const LabelsSelectAllVisible();
}

class LabelsClearSelection extends LabelsEvent {
  const LabelsClearSelection();
}

class LabelsDefaultCopiesChanged extends LabelsEvent {
  const LabelsDefaultCopiesChanged(this.copies);
  final int copies;
  @override
  List<Object?> get props => [copies];
}

class LabelsLineCopiesChanged extends LabelsEvent {
  const LabelsLineCopiesChanged(this.productId, this.copies);
  final int productId;
  final int copies;
  @override
  List<Object?> get props => [productId, copies];
}

class LabelsPrintRequested extends LabelsEvent {
  const LabelsPrintRequested();
}

class LabelsTemplateSaved extends LabelsEvent {
  const LabelsTemplateSaved({required this.draft, this.id});
  final LabelTemplateDraft draft;
  final int? id;
  @override
  List<Object?> get props => [draft, id];
}

class LabelsTemplateDeleted extends LabelsEvent {
  const LabelsTemplateDeleted(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

class LabelsRefreshRequested extends LabelsEvent {
  const LabelsRefreshRequested();
}

class LabelsMessageDismissed extends LabelsEvent {
  const LabelsMessageDismissed();
}
