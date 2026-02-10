# bloc_architecure

A new Flutter BLoC architecture project.

## Getting Started

folder structure rules:

1. Cubit = UI state only
2. Bloc = business flow only
3. View = bridge + rendering

# Use mason to create boilerplate code:

```bash
dart pub global activate mason_cli
```

```bash
mason init
```

create new brick(mold) move this mold at /mason/bricks/:

```bash
mason new hybrid_feature
```

```bash
mason new bloc_feature
```

```bash
mason new cubit_feature
```

register brick(mold) or manually register in mason.yaml file:

```bash
mason add hybrid_feature --path mason/bricks/hybrid_feature
```

```bash
mason add bloc_feature --path mason/bricks/bloc_feature
```

```bash
mason add cubit_feature --path mason/bricks/cubit_feature
```

create feature(screen) with test:

```bash
mason make hybrid_feature --name login --project_name bloc_architecure -o .
```

```bash
mason make bloc_feature --name login1 --project_name bloc_architecure -o .
```

```bash
mason make cubit_feature --name login2 --project_name bloc_architecure -o .
```

create feature only or test only:

```bash
mason make hybrid_feature --name login --project_name bloc_architecure -o lib
```
```bash
mason make hybrid_feature --name login --project_name bloc_architecure -o test
```

```bash
mason make bloc_feature --name login --project_name bloc_architecure -o lib
```
```bash
mason make bloc_feature --name login --project_name bloc_architecure -o test
```

```bash
mason make cubit_feature --name login --project_name bloc_architecure -o lib
```
```bash
mason make cubit_feature --name login --project_name bloc_architecure -o test
```