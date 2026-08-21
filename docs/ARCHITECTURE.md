# Flutter Architecture

This document is the authoritative architecture reference for the Flutter application.

It defines where code belongs, how layers communicate, how state management is chosen, how dependencies are owned, and which dependency directions are allowed.

The architecture is intentionally pragmatic: boundaries should improve maintainability without creating ceremony for its own sake.

## 1. Architectural Style

The application uses:

```text
Feature-First Organization
        +
Pragmatic Clean Architecture
        +
Cubit / Bloc
        +
Repository Pattern
        +
Dependency Injection
```

Primary structure:

```text
lib/
├── gen/
└── src/
    ├── app/
    ├── core/
    └── features/
```

Responsibilities:

```text
app/
    application-wide composition and configuration

core/
    genuinely shared infrastructure and reusable primitives

features/
    business capabilities owned vertically by feature
```

## 2. App Layer

`src/app/` owns application-wide configuration and composition.

Typical responsibilities:

```text
app/
├── bloc/
├── config/
├── di/
├── router/
├── theme/
└── app.dart
```

Examples:

- application startup;
- global session/application state;
- routing;
- dependency registration;
- environment/configuration wiring;
- theme;
- app-wide initialization.

Feature-specific business logic must not be placed here.

## 3. Core Layer

`src/core/` contains concerns genuinely shared across unrelated features.

Typical examples:

```text
core/
├── constants/
├── enums/
├── errors/
├── logging/
├── services/
├── utils/
├── widgets/
└── usecase/
```

`core/` is not a miscellaneous folder.

Feature-specific logic must remain inside its feature.

Avoid vague dumping-ground files such as:

```text
helpers.dart
common.dart
misc.dart
functions.dart
utils2.dart
```

when a clearer responsibility exists.

## 4. Feature Structure

A meaningful business feature normally follows:

```text
features/
└── feature_name/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/
```

Not every trivial feature requires every folder.

Do not create empty or meaningless layers only to match the diagram.

## 5. Dependency Direction

The architecture follows inward dependencies:

```text
presentation → domain
data         → domain
domain       → no feature infrastructure/presentation
```

Conceptually:

```text
                 ┌─────────────────┐
                 │  Presentation   │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │     Domain      │
                 └─────────────────┘
                          ▲
                          │
                 ┌────────┴────────┐
                 │      Data       │
                 └─────────────────┘
```

The domain layer owns contracts.

The data layer implements them.

Presentation must not depend directly on repository implementations, data sources, or external SDK clients.

## 6. Normal Runtime Flow

For non-trivial business operations:

```text
User
 ↓
Widget / Page
 ↓
Cubit or Bloc
 ↓
Use Case
 ↓
Repository Contract
 ↓
Repository Implementation
 ↓
Data Source
 ↓
External System
```

Results normally return as:

```text
External System
 ↓
Data Source
 ↓
Repository
 ↓
Either<Failure, T>
 ↓
Use Case
 ↓
Cubit / Bloc
 ↓
State
 ↓
Widget
```

## 7. Presentation Layer

Presentation contains:

```text
presentation/
├── bloc/
├── pages/
└── widgets/
```

Presentation responsibilities:

- render UI;
- receive user interaction;
- dispatch Cubit methods or Bloc events;
- react to state;
- trigger UI-only side effects;
- perform presentation-only formatting.

Presentation must not:

- query a database directly;
- call Supabase/Firebase/REST SDKs directly;
- instantiate repository implementations;
- contain reusable business rules.

## 8. Cubit vs Bloc

Both Cubit and Bloc are valid because both are part of `flutter_bloc`.

Choose based on event-flow complexity.

### Prefer Cubit

Use Cubit when state changes map directly to explicit commands.

Typical examples:

```text
load()
refresh()
submit()
delete()
toggle()
select()
loadNextPage()
```

Cubit is appropriate for:

- straightforward loading/success/failure flows;
- simple forms;
- CRUD;
- basic filters;
- simple data screens;
- controlled pagination without meaningful event races.

Cubit should be the default when adding event classes would only add boilerplate.

### Prefer Bloc

Use Bloc when an explicit event stream provides value.

Typical examples:

- debounce;
- throttle;
- restartable work;
- droppable work;
- concurrent processing;
- event ordering;
- overlapping user actions;
- search-as-you-type;
- real-time/event-driven flows;
- pagination combined with refresh/search/filter where events may race.

A large state object does not by itself require Bloc.

Pagination alone does not by itself require Bloc.

## 9. State Representation

New Cubit and Bloc states use Freezed.

For most feature screens, prefer a single immutable state object plus status/data fields when that is the clearest model.

Example:

```dart
@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default(ProductStatus.initial) ProductStatus status,
    @Default(<Product>[]) List<Product> products,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    Failure? failure,
  }) = _ProductState;
}
```

Use Freezed sealed/union states when states are genuinely mutually exclusive and modeling them as separate cases improves clarity.

Do not use unions automatically merely because Freezed supports them.

Freezed classes already provide equality, so do not combine Freezed state classes with `Equatable`.

## 10. Cubit/Bloc Responsibilities

Cubit/Bloc may:

- invoke use cases;
- coordinate application operations;
- maintain presentation/application state;
- translate domain results into presentation state;
- coordinate refresh/loading/submission behavior.

Cubit/Bloc must not:

- call external APIs directly;
- query databases directly;
- access Supabase/Firebase SDKs directly;
- contain widget code;
- hold `BuildContext`;
- perform direct navigation;
- show dialogs/snackbars;
- contain large reusable business algorithms that belong in domain/application logic.

Avoid god Cubits/Blocs.

## 11. One-Off UI Side Effects

Rendering and one-off effects are different responsibilities.

Use:

```text
BlocBuilder / BlocSelector
    → rendering

BlocListener
    → one-off UI effects

BlocConsumer
    → both, only when genuinely useful
```

Examples of listener-driven effects:

- navigation;
- snackbar;
- dialog;
- bottom sheet;
- focus request;
- closing a page after success.

Expected flow:

```text
Business operation
      ↓
Cubit / Bloc
      ↓
State
      ↓
BlocListener
      ↓
UI side effect
```

Do not inject `BuildContext`, `Navigator`, or `ScaffoldMessenger` into Cubits/Blocs.

## 12. Cubit/Bloc Ownership and Lifecycle

A feature page or deliberate parent scope normally owns a feature Cubit/Bloc.

Typical pattern:

```dart
BlocProvider(
  create: (_) => getIt<ExpenseCubit>(),
  child: const ExpensePage(),
)
```

Child widgets consume the existing instance using the project-standard APIs.

Do not create another feature Cubit/Bloc deep inside a child widget unless that child intentionally owns an independent state scope.

When `BlocProvider(create: ...)` creates the state object, the provider owns its lifecycle.

Do not manually call `close()` on that instance.

Use `BlocProvider.value` only when intentionally passing an already-existing instance whose lifecycle is owned elsewhere.

## 13. Dependency Injection

Dependencies are composed through the existing project DI mechanism.

Prefer constructor injection:

```dart
class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(this._getExpenses);

  final GetExpenses _getExpenses;
}
```

Do not use service-locator lookups inside domain/application classes:

```dart
final repository = getIt<ExpenseRepository>();
```

inside a Cubit, Bloc, use case, or repository is discouraged.

The composition layer may use the DI container to build the graph.

Business classes receive dependencies through constructors.

Do not introduce another DI framework without an explicit architecture decision.

## 14. Domain Layer

Domain represents business concepts independently of UI and infrastructure.

Typical structure:

```text
domain/
├── entities/
├── repositories/
└── usecases/
```

Domain must not depend on:

- Flutter widgets;
- presentation code;
- Supabase/Firebase SDKs;
- HTTP/database clients;
- repository implementations.

Repository contracts belong here.

Example:

```dart
abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();
}
```

## 15. Use Cases

Use cases represent meaningful application/business actions.

Examples:

```text
GetExpenses
CreateExpense
DeleteExpense
CalculateDailySummary
GenerateReport
```

Use cases depend on repository contracts.

They should be used when they provide value through:

- business rules;
- orchestration;
- reuse;
- a stable application boundary.

Do not create ceremonial use cases around trivial values merely to increase layer count.

Follow established project patterns.

## 16. Data Layer

The data layer owns infrastructure-specific behavior.

Typical structure:

```text
data/
├── datasources/
├── models/
└── repositories/
```

Responsibilities include:

- API/database/SDK communication;
- serialization;
- DTO/model mapping;
- caching where applicable;
- translating infrastructure exceptions;
- repository implementations.

## 17. Data Sources

Data sources communicate with external systems.

They may know about:

- HTTP clients;
- Supabase/Firebase SDKs;
- database clients;
- local storage;
- platform APIs.

They may throw known typed infrastructure exceptions.

Those exceptions must not leak beyond the repository boundary.

## 18. Repository Boundary and fpdart

Repository contracts use:

```dart
Either<Failure, T>
```

from `fpdart`.

Repository contracts live under:

```text
domain/repositories/
```

Implementations live under:

```text
data/repositories/
```

Expected failure flow:

```text
External SDK / API error
       ↓
Typed infrastructure exception
       ↓
Repository implementation
       ↓
Failure
       ↓
Either<Failure, T>
```

Do not introduce competing result wrappers.

For operations without a meaningful success value, use the project's established `fpdart` success representation such as `Unit` when appropriate.

## 19. Freezed Models and JSON

New API/database response models should use:

```text
Freezed
    +
json_serializable
```

Typical source:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response_model.freezed.dart';
part 'user_response_model.g.dart';

@freezed
abstract class UserResponseModel with _$UserResponseModel {
  const factory UserResponseModel({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _UserResponseModel;

  factory UserResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UserResponseModelFromJson(json);
}
```

Generated files must not be edited manually.

Freezed handles immutable value behavior such as equality and `copyWith`.

`json_serializable` handles JSON conversion.

Existing Equatable/manual models do not need migration unless touched by a meaningful feature/refactor.

## 20. Domain Entities

Domain entities may use:

- Freezed when immutable value-style modeling is useful;
- plain immutable Dart when domain behavior is clearer that way.

Do not force every domain class into Freezed.

Do not use generated data models as the domain model automatically when infrastructure shape and business meaning differ.

## 21. Failure Handling

Use the shared `Failure` hierarchy.

Examples may include:

```text
NetworkFailure
ServerFailure
AuthenticationFailure
ValidationFailure
CacheFailure
UnexpectedFailure
```

Feature-specific failures may exist when the distinction has genuine business value.

UI should never display raw SDK exception strings directly.

## 22. Widget Architecture

Flutter UI follows compositional, Lego-style design.

A screen should make its high-level structure readable.

Prefer:

```dart
class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SalesSummarySection(),
        SalesChartSection(),
        RecentSalesSection(),
      ],
    );
  }
}
```

over one very large page containing every implementation detail.

## 23. Widget Extraction

Extract a widget when it forms a meaningful UI unit or improves:

- readability;
- reuse;
- testing;
- rebuild boundaries;
- responsibility separation.

Do not extract every small `Text`, `Padding`, or simple layout fragment merely to reduce file length.

The goal is composition, not fragmentation.

## 24. Feature-Local vs Shared Widgets

Feature-only widgets belong in:

```text
features/<feature>/presentation/widgets/
```

Global/shared widgets belong in:

```text
core/widgets/
```

Promotion rule:

```text
One feature
   ↓
Feature-local

Genuine reuse across unrelated features
   ↓
Shared/core
```

Use:

```text
Local first.
Shared when proven.
```

## 25. Cross-Feature Boundaries

One feature should not depend on another feature's presentation internals.

Avoid patterns such as:

```text
reports/
  imports
expenses/presentation/bloc/expense_cubit.dart
```

for ordinary feature communication.

Shared business capabilities should be exposed through deliberate domain/application abstractions instead of presentation coupling.

## 26. Routing

Use the existing router.

Cubit/Bloc must not perform direct navigation.

Presentation reacts to state and performs navigation through the established router.

Do not introduce a second routing solution.

## 27. Theme and Design System

Use existing centralized design tokens when available:

```text
AppColors
AppSpacing
AppRadius
AppTypography
AppTheme
```

Avoid scattering repeated arbitrary colors, spacing, radii, or typography values when equivalent project tokens already exist.

## 28. Local UI State

Not every state belongs in Cubit/Bloc.

Local state is appropriate for ephemeral presentation details such as:

- animation controllers;
- focus;
- text editing controllers;
- temporary expanded/collapsed state;
- UI-only selection with no business significance.

Business/application state belongs in Cubit/Bloc.

Use the smallest appropriate owner.

## 29. Secrets and Environment Configuration

Never embed privileged secrets inside the Flutter application.

Do not hard-code:

- backend service credentials;
- admin/service-role keys;
- private tokens;
- database passwords;
- private signing secrets.

Client-safe configuration should flow through the project's existing configuration/environment layer.

A value bundled into a Flutter client must be treated as discoverable by end users.

Privileged operations requiring true secrets belong on trusted backend infrastructure.

## 30. Testing Architecture

Testing effort should follow risk and logic.

Expected defaults:

```text
Pure business/domain logic
    → unit test expected

Cubit/Bloc with meaningful branching
    → bloc_test expected

Repository mapping/failure conversion
    → unit test when non-trivial

Complex reusable widget behavior
    → widget test when valuable

Simple presentational widget
    → test not automatically required
```

When fixing a reproducible bug, add a regression test when practical.

Tests should validate behavior, not implementation trivia.

## 31. Canonical Features

As stable features are completed, designate canonical references.

Examples:

```text
Canonical CRUD feature:
features/<feature>/

Canonical form feature:
features/<feature>/

Canonical paginated feature:
features/<feature>/
```

Before implementing similar functionality, inspect the closest canonical feature and mirror its conventions.

Until canonical features are formally designated, inspect the most complete similar existing implementation.

## 32. Pragmatic Clean Architecture

Clean Architecture is a boundary system, not a class-count target.

Do not create unnecessary:

```text
UseCase
Repository
RepositoryImpl
DataSource
Wrapper
Manager
Factory
Adapter
```

for trivial behavior when the abstraction provides no meaningful benefit.

Use architecture where it protects:

- business logic;
- data boundaries;
- testability;
- replaceability;
- feature ownership;
- maintainability.

## 33. Architecture Decision Priority

When deciding how to implement something, use:

```text
1. Explicit feature/product requirement
2. Existing project architecture
3. This architecture document
4. docs/RULES.md
5. Closest canonical/similar implementation
6. Flutter/Dart best practice
7. AI/developer personal preference
```

Personal preference must not silently override established project architecture.
