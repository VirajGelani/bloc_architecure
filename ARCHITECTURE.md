## Hybrid (Cubit + Bloc) Rules

### State Ownership

- Cubit owns UI state (`*_ui_state.dart`)
- Bloc owns flow/business state (`*_state.dart`)

### UI Binding Rules

- UI MUST render from Cubit state only
- UI MUST NOT render from Bloc state
- `BlocBuilder<Bloc, State>` is NOT allowed in views
- `BlocListener<Bloc, State>` is allowed for reactions only

### Upgrade Rule

- Cubit-only → Hybrid MUST NOT change Cubit state
- UI layout MUST NOT change during upgrade
- Hybrid adds Bloc; it does not replace Cubit

### Naming Rules

- UI state files end with `_ui_state.dart`
- UI cubits end with `_ui_cubit.dart`
- Bloc files use `_bloc.dart`, `_event.dart`, `_state.dart`
- Views end with `_view.dart`

### Mason Generation Rules

- Feature bricks generate lib/ only
- Test bricks generate test/ only
- Combined generation is explicit

### Test Generation Rule

- All Mason-generated features must include tests
- Cubit-only → Cubit tests only
- Bloc-only → Bloc tests only
- Hybrid → Both Cubit & Bloc tests

### Testing Rules

- UI Cubits test UI state only
- Blocs test flow state only
- Hybrid features reuse Cubit + Bloc tests
- Views are not unit-tested

Violation of these rules is a PR rejection.

1. Overview

This project follows a strict Hybrid BLoC architecture using:

BLoC (business/domain logic)

Cubit (pure UI state)

Freezed (immutable snapshot state)

GetIt (dependency injection)

Dio (networking)

GetStorage (local persistence)

GetX is completely removed from state management and navigation.

2. Core Architectural Principles
   2.1 Strict Separation of Concerns
   Layer	Responsibility
   View	Rendering + Navigation
   Bloc	Business logic + Domain state
   Cubit	UI-only state
   Repository	Data orchestration
   Services	Infrastructure (API, Storage, Audio, etc.)
   Interceptors	Request/Response handling only

No layer may violate responsibility boundaries.

3. Hybrid Pattern (Cubit + Bloc)

Each feature may follow:

feature/
├── bloc/
├── cubit/
├── view/
└── di/

3.1 Bloc Responsibilities

Bloc owns:

API calls

Business logic

Domain flow

Repetition engines

Audio orchestration decisions

Auth state

Progress tracking

Business loading (isLoading)

Domain error (error)

Bloc must NOT:

Navigate

Show SnackBars

Control animations

Store UI-only flags

3.2 UiCubit Responsibilities

UiCubit owns:

Visual toggles

Animation flags

Scroll state

Temporary UI selections

Page effects

UiCubit must NOT contain:

isLoading

error

API results

Business logic state

3.3 Decision Rule

When deciding where a variable belongs:

If removing it breaks business flow → Bloc
If removing it only affects visuals → Cubit

4. Freezed Usage Rules

All Bloc states and events use Freezed.

4.1 Snapshot State Pattern

Bloc state is a snapshot:

@freezed
class FeatureState with _$FeatureState {
const factory FeatureState({
@Default(false) bool isLoading,
String? error,
required EngineState engine,
required AudioState audio,
}) = _FeatureState;
}


No subclass states like Loading, Success, etc.

4.2 Sub-Model Rule (Mandatory for Complex Features)

Complex features must group logic into Freezed sub-models:

FeatureState
├── EngineState (Freezed)
├── AudioState (Freezed)
└── Optional ProgressState


Do NOT store large unrelated maps directly in root state.

4.3 Event Handling Pattern

Never reference private event classes like _Started.

Use:

on<FeatureEvent>((event, emit) async {
await event.when(
started: () => _onStarted(emit),
);
});


Do NOT use:

on<_Started>

5. Loading Rule

There are two types of loading:

5.1 Business Loading (Bloc)

Represents:

API in progress

Repetition engine running

Firestore syncing

Audio preloading

Stored in Bloc state as isLoading.

5.2 Visual Loading (Cubit)

Represents:

Button shimmer

Page fade animation

UI animation effects

Stored in UiCubit.

6. Networking Layer
   6.1 ApiService

Plain Dart class

Registered via GetIt

No GetX

No navigation

No UI logic

6.2 AuthInterceptor

Interceptor must:

Attach access token

Refresh token on 401

Notify session manager on failure

Interceptor must NOT:

Navigate

Show SnackBars

Access UI

7. Auth Flow Architecture
   AuthInterceptor
   ↓
   AuthSessionManager (Stream)
   ↓
   AuthBloc
   ↓
   Root View (BlocListener)
   ↓
   Navigation


Navigation happens only in View.

8. Storage Layer
   8.1 AppStorageService

Plain Dart class

Wraps GetStorage

Injected via GetIt

No GetxService

Storage must never be accessed directly from UI.

Access flow:

View → Bloc → Repository → Storage


Interceptor may use GetIt directly.

9. Dependency Injection

All dependencies are registered via GetIt.

Constructor injection is mandatory for:

Bloc

Repository

Services

Direct GetIt.I<T>() allowed only in infrastructure layers (e.g., Interceptor).

10. Single Master Bloc Rule (Engine Features)

Engine-like features (e.g., Sanskrit Learning screen) must use:

Single master Bloc

Freezed snapshot state

Sub-model classes

Audio as Service (not separate Bloc)

Do NOT split into multiple blocs unless domains are fully independent.

11. Mason Brick Standard

Hybrid feature template must:

Use Freezed snapshot state

Use Freezed sub-models

Use event.when()

Avoid private event classes

Use absolute imports

Contain no domain variables in boilerplate

Test files must:

Use bloc_test

Test snapshot equality

Not rely on subclass states

12. Absolute Import Rule

Never use relative imports in features.

Always:

import 'package:project_name/features/...';

13. Clean Architecture Enforcement

Strictly prohibited:

Navigation in Interceptors

Snackbar in Repository

UI logic in Services

Business logic in View

Domain flags in UiCubit

Animation flags in Bloc

14. Final Architectural Philosophy

Bloc = Domain Brain
Cubit = Presentation Brain
Service = Infrastructure
Repository = Data Layer
View = Rendering + Navigation

All states are immutable.
All business logic lives in Bloc.
All UI logic lives in Cubit.
All layers are independent.
