import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_cubit.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_state.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_event.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}View extends StatelessWidget {
const {{name.pascalCase()}}View({super.key});

@override
Widget build(BuildContext context) {
return MultiBlocProvider(
providers: [
BlocProvider(create: (_) => GetIt.I<{{name.pascalCase()}}Bloc>()..add(const {{name.pascalCase()}}Event.started())),
BlocProvider(create: (_) => GetIt.I<{{name.pascalCase()}}UiCubit>()),
],
child: BlocBuilder<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
builder: (context, state) {
return const Scaffold(
body: Center(
child: Text('{{name.pascalCase()}} View'),
),
);
},
),
);
}
}
