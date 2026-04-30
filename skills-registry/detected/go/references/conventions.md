# Go Conventions

- Handle all errors explicitly — never discard with `_`
- Exported names are capitalized, unexported are lowercase
- Accept interfaces, return structs
- Table-driven tests with t.Run subtests
- Use context.Context for cancellation and deadlines
- Prefer small interfaces (1-3 methods)
- Use `errors.Is`/`errors.As` for error checking
