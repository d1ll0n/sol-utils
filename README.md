## `ir-only`

The `ir-only` subdirectory contains libraries which are designed for use with solc's ir pipeline and will not be gas efficient without `viaIR` and optimization enabled. This is largely due to the use of internal functions which are expected to be inlined by the compiler.

## `non-ir-only`

The `non-ir-only` subdirectory contains libraries which are designed for use without solc's ir pipeline and will not be gas efficient when `viaIR` is enabled. This is mostly relevant for jump tables, as `viaIR` removes solc's handling of function pointers as jumpdests.