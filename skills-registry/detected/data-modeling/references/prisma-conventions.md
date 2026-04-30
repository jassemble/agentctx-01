# Prisma Conventions

- Use explicit `@relation` names for clarity
- Add `@@index` for fields used in WHERE/ORDER BY
- Use `@updatedAt` for automatic timestamps
- Soft delete with `deletedAt DateTime?` over hard delete
- Use enums for fixed sets of values
- Name migrations descriptively: `add_user_role_column`
