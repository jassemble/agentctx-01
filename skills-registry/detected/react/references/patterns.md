# React Patterns

## Component Patterns
- Container/Presentational separation
- Compound components for complex UI
- Render props for cross-cutting behavior

## State Management
- Local state with useState for component-scoped data
- Context for theme/auth/locale (low-frequency updates)
- External store (Zustand/Redux) for high-frequency shared state

## Performance
- useMemo/useCallback only after measuring
- Virtualize long lists (react-window)
- Code-split routes with React.lazy
