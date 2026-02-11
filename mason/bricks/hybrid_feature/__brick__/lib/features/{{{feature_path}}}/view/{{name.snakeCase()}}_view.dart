import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_cubit.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_state.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}View extends StatelessWidget {
const {{name.pascalCase()}}View({super.key});

@override
Widget build(BuildContext context) {
return BlocListener<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
listener: (context, state) {
final uiCubit = context.read<{{name.pascalCase()}}UiCubit>();

if (state is {{name.pascalCase()}}Loading) {
uiCubit.setLoading(true);
}

if (state is {{name.pascalCase()}}Failure) {
uiCubit.setLoading(false);
uiCubit.setError(state.message);
}
},
child: BlocBuilder<{{name.pascalCase()}}UiCubit, {{name.pascalCase()}}UiState>(
builder: (context, ui) {
return Scaffold(
body: Center(
child: ui.isLoading
? const CircularProgressIndicator()
    : const Text('{{name.pascalCase()}} View'),
),
);
},
),
);
}
}
