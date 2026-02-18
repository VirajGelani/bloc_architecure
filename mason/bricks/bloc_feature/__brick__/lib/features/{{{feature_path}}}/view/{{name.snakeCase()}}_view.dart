import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}View extends StatelessWidget {
  const {{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => {{name.pascalCase()}}Bloc(),
      child: BlocListener<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
        listener: (_, __) {},
        child: const Scaffold(
          body: Center(
            child: Text('{{name.pascalCase()}} View'),
          ),
        ),
      ),
    );
  }
}
