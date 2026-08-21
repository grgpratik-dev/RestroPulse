# Flutter Coding Rules

These are the binding implementation conventions for human-written and AI-generated Flutter/Dart code in this project.

For layer responsibilities and dependency direction, see `ARCHITECTURE.md`.

## 1. Language and Type Safety

- Use Dart null safety intentionally.
- Prefer non-nullable types unless absence is meaningful.
- Prefer `final` when reassignment is unnecessary.
- Use `const` where it meaningfully applies.
- Avoid `dynamic` unless required at an uncontrolled external boundary.
- Use explicit types when they improve clarity.
- Do not use `!` merely to silence null-safety errors.
- Prefer guards, proper nullable modeling, or type refinement.
- Use `!` only when the invariant is guaranteed and clear.

## 2. Naming

Use standard Dart conventions:

```text
Types/classes        UpperCamelCase
Variables/functions  lowerCamelCase
Files                snake_case.dart
Private members      _prefixed
```

Prefer precise responsibility-based names:

```text
ExpenseRepository
ExpenseRepositoryImpl
GetExpenses
ExpenseCubit
ExpenseState
SalesSummaryCard
```

Avoid vague names:

```text
Helper
Manager
Common
Processor
Stuff
Utils2
DataThing
```

Boolean names should read naturally:

```text
isLoading
hasError
canSubmit
isAuthenticated
```

## 3. File Responsibility

Each file should have one clear primary responsibility.

Do not mix unrelated:

- UI;
- business logic;
- data access;
- state management;
- utilities;

inside the same file.

Do not split files solely because of an arbitrary line count.

Split when responsibilities are meaningfully different.

## 4. State Management

The project uses:

```text
flutter_bloc
```

Both Cubit and Bloc are valid.

### Cubit

Prefer Cubit for direct command-to-state behavior:

```text
load()
refresh()
submit()
delete()
toggle()
select()
loadNextPage()
```

Use Cubit when events would only add boilerplate.

### Bloc

Prefer Bloc when event-stream behavior provides value:

```text
debounce
throttle
restartable
droppable
concurrent processing
event ordering
overlapping events
real-time coordination
```

Do not choose Bloc solely because a feature contains a lot of data.

Pagination alone does not require Bloc.

## 5. Cubit/Bloc Responsibilities

Cubit/Bloc may:

- call use cases;
- coordinate operations;
- hold application/presentation state;
- translate domain results into presentation state.

Cubit/Bloc must not:

- call external APIs directly;
- query databases directly;
- access Supabase/Firebase SDKs directly;
- contain widgets;
- hold `BuildContext`;
- perform direct navigation;
- show snackbars/dialogs;
- contain large reusable business algorithms.

Avoid god Cubits/Blocs.

## 6. Freezed State Convention

New Cubit/Bloc states use Freezed.

Do not extend `Equatable` on Freezed state classes.

For most feature states, prefer a single immutable state object with status/data fields when that is clearest.

Use Freezed sealed/union states only when states are genuinely mutually exclusive and the union improves readability.

Do not use unions automatically just because Freezed supports them.

Existing Equatable states may remain unchanged unless a task already requires touching/refactoring them.

## 7. Freezed Model Convention

New API/database response models use:

```text
Freezed
+
json_serializable
```

Freezed provides immutable value behavior such as:

- structural equality;
- `copyWith`;
- `hashCode`;
- `toString`.

`json_serializable` provides:

- `fromJson`;
- `toJson`.

Do not manually implement generated behavior when the project generator already provides it.

Do not manually edit:

```text
*.freezed.dart
*.g.dart
```

Modify the source model and regenerate.

## 8. Domain Entities

Domain entities may use:

- Freezed for immutable value-style entities;
- plain immutable Dart for richer domain behavior.

Do not force all domain classes into Freezed.

Do not use `Equatable` together with Freezed.

## 9. Repository Result Type

Repository contracts use:

```dart
Either<Failure, T>
```

from `fpdart`.

Do not introduce competing wrappers such as:

```text
Result<T>
ApiResult<T>
ResponseWrapper<T>
CustomEither<T>
```

For no-value success, use the project's established `fpdart` representation such as `Unit` when appropriate.

## 10. Error Handling

Data sources may throw known typed infrastructure exceptions.

Repository implementations map them into the shared `Failure` hierarchy.

Expected flow:

```text
DataSource
   ↓ exception
Repository
   ↓
Either<Failure, T>
```

Do not leak raw SDK exceptions across repository boundaries.

Do not show raw backend/SDK error strings directly to users.

Avoid broad `catch (e)` merely to hide failures.

Map unexpected failures intentionally.

## 11. UI Side Effects

Cubit/Bloc must not own UI presentation side effects.

Use:

```text
BlocBuilder / BlocSelector
    → rendering

BlocListener
    → one-off UI effects

BlocConsumer
    → both when genuinely needed
```

Examples of listener-owned effects:

- navigation;
- snackbar;
- dialog;
- bottom sheet;
- closing a page after success;
- focus requests.

Do not pass `BuildContext` into Cubits/Blocs.

## 12. Cubit/Bloc Ownership and Lifecycle

A feature page or deliberate parent scope normally owns the feature Cubit/Bloc.

Child widgets should consume the existing instance instead of creating duplicate state owners.

When using:

```dart
BlocProvider(
  create: (_) => ...,
  child: ...,
)
```

the provider owns the created Cubit/Bloc lifecycle.

Do not manually call `close()` on it.

Use `BlocProvider.value` only for intentionally reusing an existing instance whose lifecycle is managed elsewhere.

## 13. Dependency Injection

Use the existing project DI mechanism.

Prefer constructor injection inside business/application classes.

Good:

```dart
class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit(this._getExpenses);

  final GetExpenses _getExpenses;
}
```

Avoid resolving dependencies directly inside classes:

```dart
final repository = getIt<ExpenseRepository>();
```

inside Cubits, Blocs, use cases, or repositories.

The DI/composition layer may use the service locator to build the dependency graph.

Do not introduce another DI library.

## 14. Widgets Must Stay UI-Focused

Widgets may:

- render;
- read state;
- react to state;
- dispatch actions/events;
- perform UI-only formatting;
- manage local presentation-only concerns.

Widgets must not:

- query repositories;
- query data sources;
- call external SDK/database APIs directly;
- contain significant business rules.

## 15. Lego-Style Widget Composition

Main screens should compose meaningful sections.

Prefer:

```text
DashboardPage
├── DashboardHeader
├── TodaySummary
├── RevenueOverview
├── TopItemsSection
└── AlertsSection
```

over putting every implementation detail in one page.

The parent page should make the screen structure understandable at a glance.

## 16. Widget Extraction

Extract a widget when doing so improves:

- reuse;
- readability;
- rebuild boundaries;
- testing;
- responsibility separation.

Do not extract every trivial `Text`, `Padding`, or tiny layout fragment.

The goal is composition, not fragmentation.

## 17. Feature Widgets

Feature-specific widgets belong in:

```text
features/<feature>/presentation/widgets/
```

Do not move a widget to global/shared scope merely because it might be reused later.

## 18. Shared Widgets

Widgets genuinely reused across unrelated features may live in:

```text
core/widgets/
```

Use:

```text
Local first.
Shared when proven.
```

Before creating a new shared widget, search for an existing equivalent.

## 19. Search Before Creating

Before adding a new:

- widget;
- Cubit;
- Bloc;
- repository;
- use case;
- service;
- utility;
- model;
- entity;
- enum;
- extension;
- constant;

search the existing project first.

Reuse or extend an appropriate abstraction rather than duplicating it.

## 20. Avoid Premature Abstractions

Do not create infrastructure for hypothetical future requirements.

Avoid unnecessary:

- managers;
- factories;
- wrappers;
- base classes;
- generic services;
- adapters;
- mixins;
- extension layers.

Every new abstraction should solve a current identifiable problem.

## 21. Core Folder

`core/` is reserved for genuinely shared concerns.

Do not put feature-specific code there for convenience.

Do not use `core/` as a dumping ground.

If code only makes sense inside one feature, keep it inside that feature.

## 22. Services

Global services should represent cross-cutting infrastructure such as:

```text
network
storage
session
logging
media
```

Do not hide feature business logic inside generic service classes.

## 23. Utilities

Utilities should be:

- focused;
- reusable;
- stateless where practical;
- business-agnostic.

Appropriate examples:

```text
debouncer
validation helper
keyboard utility
date formatting helper
```

Feature-specific business calculations do not belong in generic `utils/`.

## 24. Routing

Use the existing router.

Do not introduce a second navigation system.

Cubit/Bloc should not navigate directly.

Presentation handles navigation in response to state/effects.

## 25. Theme and Styling

Reuse existing design-system abstractions such as:

```text
AppColors
AppSpacing
AppRadius
AppTypography
AppTheme
```

where they exist.

Avoid repeated arbitrary visual values when a project token already represents the same concept.

Do not create a second styling system inside a feature.

## 26. Imports

Follow the import convention already established by the repository.

Do not randomly mix relative/package import styles.

Remove unused imports.

Do not import internal presentation implementation details from unrelated features.

## 27. Generated Code

Never manually edit generated code.

Examples:

```text
*.freezed.dart
*.g.dart
generated assets
generated localization output
```

Modify the source declaration/configuration and rerun the generator.

## 28. Comments

Comments should explain **why**, not repeat **what** the code does.

Useful comments explain:

- non-obvious constraints;
- workarounds;
- domain rules;
- architectural deviations;
- external API/platform quirks.

Readable code should explain normal behavior itself.

## 29. Logging

Do not leave arbitrary:

```dart
print(...)
```

statements in production code.

Use the established logging mechanism.

Never log:

- passwords;
- access tokens;
- private credentials;
- secrets;
- sensitive personal payloads.

## 30. Async Code

Do not start uncontrolled business/data operations inside widget `build()`.

Consider:

- duplicate requests;
- stale requests;
- failures;
- loading state;
- cancellation;
- concurrency;
- refresh/load-more conflicts.

Use Bloc when event-stream concurrency needs explicit control.

## 31. Pagination

Pagination does not automatically require Bloc.

Cubit is appropriate when:

```text
loadInitial()
loadNextPage()
refresh()
```

are controlled and meaningful request races do not occur.

Prefer Bloc when pagination interacts with:

- rapid scroll events;
- search;
- changing filters;
- refresh;
- overlapping requests;
- restartable/droppable behavior.

Choose based on event behavior, not data size.

## 32. Local UI State

Do not put every state value in Cubit/Bloc.

Local widget state is appropriate for ephemeral presentation details such as:

- animations;
- focus;
- controllers;
- temporary expansion;
- UI-only selection with no business significance.

Application/business state belongs in Cubit/Bloc.

## 33. Secrets and Environment Configuration

Never hard-code privileged secrets in Flutter source.

Do not embed:

- backend admin keys;
- service credentials;
- database passwords;
- private signing secrets;
- private access tokens.

Client-safe environment/config values should use the established config mechanism.

Anything shipped in a Flutter client must be treated as discoverable.

Privileged operations requiring true secrets belong on trusted backend infrastructure.

## 34. Testing Expectations

Testing should follow risk and logic.

Default expectations:

```text
Pure business/domain logic
    → unit test expected

Cubit/Bloc with meaningful branching
    → bloc_test expected

Repository mapping/failure conversion
    → unit test when non-trivial

Complex reusable widget behavior
    → widget test when useful

Simple presentational widget
    → test not automatically required
```

When fixing a reproducible bug, add a regression test when practical.

Test behavior, not internal implementation trivia.

## 35. Performance

Do not prematurely optimize.

Avoid obvious problems such as:

- expensive work in `build()`;
- duplicate network requests;
- unnecessarily large rebuilds;
- recreating controllers during builds;
- fetching much more data than needed.

Use meaningful widget boundaries to isolate rebuilds.

## 36. Package Dependencies

Do not add a package solely because it saves a few lines.

Before adding one:

1. check Flutter/Dart built-ins;
2. check existing dependencies;
3. confirm it solves a real need;
4. prefer maintained, established packages.

Do not replace established architecture packages without explicit approval.

## 37. Refactoring Discipline

When implementing a task:

- modify only relevant code;
- preserve unrelated behavior;
- avoid broad restructuring;
- avoid opportunistic rewrites;
- avoid unrelated renaming.

A feature request is not permission to redesign the application.

Surface necessary architectural refactors instead of performing them silently.

## 38. Existing Patterns and Canonical Features

When adding functionality similar to existing code:

1. inspect the closest implementation;
2. match folder structure;
3. match naming;
4. match state style;
5. match error handling;
6. match DI;
7. reuse shared components.

When canonical features are designated, use the closest canonical feature as the primary implementation reference.

Existing project conventions take priority over AI preference.

## 39. Verification

After implementation, run:

```bash
dart format .
flutter analyze
```

Run relevant tests:

```bash
flutter test
```

When Freezed/JSON declarations change, run the project's configured build-runner command before analysis/tests.

Do not finish with analyzer/test failures introduced by the change.

## 40. AI-Specific Restrictions

AI agents must not:

- change architecture without being asked;
- introduce another state-management library;
- bypass repository boundaries;
- call data sources directly from UI;
- replace `Either<Failure, T>`;
- combine Equatable with new Freezed state/model classes;
- create duplicate components without searching first;
- promote feature code to `core/` speculatively;
- create layers merely for Clean Architecture ceremony;
- perform unrelated refactors;
- manually edit generated files;
- pass `BuildContext` into Cubits/Blocs;
- navigate directly from Cubits/Blocs;
- resolve arbitrary service-locator dependencies inside business classes;
- expose privileged secrets in the Flutter client;
- silence typing/nullability issues with unsafe shortcuts;
- add packages without a concrete need.

The target is not code that demonstrates the maximum number of patterns.

The target is code that looks as though it has always belonged in this project.
