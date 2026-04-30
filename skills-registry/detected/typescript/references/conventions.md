# TypeScript Conventions

- Prefer `interface` over `type` for object shapes
- Use `unknown` instead of `any`, then narrow with type guards
- Discriminated unions for state: `{ status: 'loading' } | { status: 'error'; error: Error }`
- Leverage inference — don't annotate what TS can figure out
- Use `satisfies` for type-checking without widening
- Prefer `readonly` for immutable data
- Use `as const` for literal types
