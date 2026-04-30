# Python Conventions

- Type hints on all function signatures
- PEP 8 style (enforced by ruff/black)
- Dataclasses or Pydantic for structured data
- pathlib over os.path
- Context managers for resource cleanup
- f-strings over .format() or %
- Use `__all__` for public API in modules
