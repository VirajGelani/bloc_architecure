import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name}}/widgets/app_scaffold.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_cubit.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_state.dart';

class {{name.pascalCase()}}View extends StatelessWidget {
  const {{name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{{name.pascalCase()}}UiCubit, {{name.pascalCase()}}UiState>(
      builder: (context, ui) {
        return AppScaffold(
          body: Center(
            child: Text('{{name.pascalCase()}} View'),
          ),
        );
      },
    );
  }
}
