# Project Guidance for AI Coding Agents

This file is the entry point for AI-assisted development in this Flutter project.

The goal is to ensure generated code follows the architecture, patterns, naming, and development style already established in this repository.

AI coding agents must work **within the existing architecture** rather than inventing new patterns for individual tasks.

## Required Reading

Before implementing or modifying Flutter application code, read:

- `docs/ARCHITECTURE.md`
- `docs/RULES.md`

These documents are authoritative for project architecture and coding conventions.

Before changing an existing feature, also inspect:

1. the affected feature;
2. a similar existing feature;
3. existing shared abstractions that may already solve the problem.

Do not begin by generating new files before understanding the existing implementation.

## Project Baseline

The project uses:

- feature-first organization;
- pragmatic Clean Architecture;
- `flutter_bloc`;
- Cubit for simpler direct state flows;
- Bloc when explicit event processing or event concurrency provides value;
- `fpdart` with `Either<Failure, T>` across repository boundaries;
- Freezed for new Cubit/Bloc states and immutable data/response models;
- `json_serializable` for JSON serialization;
- dependency injection through the existing project DI mechanism;
- composable, Lego-style Flutter UI;
- feature-local components by default;
- shared components only after genuine cross-feature reuse.

Do not introduce an alternative architecture or competing package for an already-solved concern unless explicitly requested.

## Normal Runtime Flow

For non-trivial business features, the normal flow is:

```text
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
External API / Database / SDK
```

Results normally return through:

```text
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
UI
```

Use Clean Architecture pragmatically. Do not create meaningless layers solely to satisfy a diagram.

## Cubit vs Bloc

Use the simplest state-management abstraction that correctly models the feature.

Prefer **Cubit** when actions map directly to state transitions and no special event-stream behavior is required.

Examples:

- load data;
- refresh;
- submit a form;
- simple CRUD;
- toggle/select;
- controlled pagination;
- straightforward loading/success/failure flows.

Prefer **Bloc** when explicit event processing is useful.

Examples:

- debounce;
- throttle;
- restartable work;
- droppable work;
- overlapping events;
- event ordering;
- concurrent event handling;
- search-as-you-type;
- real-time/event-driven flows;
- pagination combined with search/filter/refresh where events may race.

Do not choose Bloc merely because the state contains a lot of data.

Do not force an event-heavy workflow into Cubit merely to reduce boilerplate.

## State and Models

For new code:

- Cubit/Bloc states use Freezed.
- API/database response models use Freezed + `json_serializable`.
- Do not extend `Equatable` on Freezed classes.
- Existing Equatable code does not need to be migrated unless the task already requires touching it.
- Domain entities may use Freezed or plain immutable Dart depending on the domain behavior and existing project conventions.

Do not manually edit generated files such as:

- `*.freezed.dart`
- `*.g.dart`

Modify the source declaration and regenerate instead.

## UI Rules

Screens should primarily compose meaningful widgets.

Feature-only widgets belong in:

```text
features/<feature>/presentation/widgets/
```

Widgets genuinely reused by unrelated features may move to:

```text
core/widgets/
```

Use the rule:

```text
Local first.
Shared when proven.
```

Do not extract trivial widgets merely to reduce line count.

Do not place business logic or direct data access in widgets.

## Side Effects

Cubit/Bloc must not contain:

- `BuildContext`;
- `Navigator`;
- `ScaffoldMessenger`;
- dialog presentation;
- route objects;
- direct UI manipulation.

Use presentation listeners for one-off UI effects:

- `BlocListener` for side effects;
- `BlocBuilder` / `BlocSelector` for rendering;
- `BlocConsumer` only when both are genuinely needed.

## Dependency Injection and Ownership

Use constructor injection inside classes.

Do not resolve arbitrary dependencies from the service locator inside repositories, use cases, Cubits, or Blocs.

A page or deliberate parent scope normally owns a feature Cubit/Bloc through `BlocProvider`.

Child widgets should consume the existing instance rather than creating duplicate state owners.

Do not manually close Cubits/Blocs created by `BlocProvider(create: ...)`; the provider owns their lifecycle.

## Error Handling

Repository contracts use:

```dart
Either<Failure, T>
```

from `fpdart`.

Data sources may throw known infrastructure exceptions.

Repository implementations map those exceptions into the shared `Failure` hierarchy.

Do not:

- introduce another result wrapper;
- leak SDK exceptions across repository boundaries;
- show raw infrastructure exception messages directly to users.

## Secrets and Configuration

Never hard-code:

- private API keys;
- service credentials;
- access tokens;
- database passwords;
- backend/admin secrets.

Client-safe configuration should use the project's configuration/environment mechanism.

Secrets that grant privileged backend access must never be shipped inside a Flutter client.

## Scope Discipline

For every task:

1. inspect before creating;
2. reuse existing abstractions where appropriate;
3. make the smallest coherent change;
4. do not refactor unrelated code;
5. do not introduce a new architecture when the existing one works;
6. do not add packages without a concrete need;
7. do not manually edit generated code.

If a larger architectural change appears necessary, surface it rather than silently redesigning the project.

## Verification

After modifying Dart/Flutter code, run as applicable:

```bash
dart format .
flutter analyze
flutter test
```

When generated code is affected, run the project's existing build-runner command before analysis/tests.

Review the final diff for architectural violations and unrelated changes.

## Final Self-Check

Before considering a task complete, verify:

- Does the code look like it belongs in this repository?
- Did I inspect and reuse existing patterns?
- Is Cubit vs Bloc appropriate for the actual event behavior?
- Are new states/models using the established Freezed convention?
- Is business logic outside widgets?
- Is presentation isolated from infrastructure?
- Does the repository boundary use `Either<Failure, T>`?
- Are one-off UI effects handled by presentation listeners?
- Is state ownership clear?
- Did feature-specific code remain feature-local?
- Did I avoid duplicate abstractions?
- Did I avoid exposing secrets?
- Did I keep the change scoped?
- Do formatting, analysis, and relevant tests pass?
