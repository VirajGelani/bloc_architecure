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
