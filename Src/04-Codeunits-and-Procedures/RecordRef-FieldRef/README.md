## RecordRef & FieldRef — Generic Record Handling

### What it is
`RecordRef` is a reference to any record in any table, determined 
at runtime rather than compile time. `FieldRef` gives dynamic 
access to individual fields on that record. Together they enable 
**table-agnostic, generic code** — one codeunit that works for 
any table without modification.

### Files

| File | Purpose |
|---|---|
| `AuditChangeLogger` | Detects and logs field changes on ANY table using RecordRef/FieldRef |
| `GenericRecordHelper` | Utility procedures: count records, list fields, copy fields, find by key |
| `RecordRefDemoRunner` | Runnable demos: change detection, table inspection, field copy |

### Key concepts

**RecordRef.Open(TableNo)** — opens any table by its table number.  
**RecordRef.GetTable(Record)** — converts a typed record variable 
into a RecordRef (the bridge between specific and generic).  
**RecordRef.FieldIndex(N)** — accesses field by sequential position (1, 2, 3...).  
**RecordRef.Field(FieldNo)** — accesses field by its defined field 
number (NOT the same as position — field numbers are often non-sequential).  
**FieldRef.Value** — reads or writes the field's value dynamically.  
**FieldRef.Class** — tells you if the field is Normal, FlowField, 
or FlowFilter — important to check before reading/comparing values.  
**KeyRef** — dynamic access to a table's key definitions.

### Field() vs FieldIndex() — critical distinction

| Method | Takes | Use when |
|---|---|---|
| `Field(FieldNo)` | Field number as defined in table object | You know the specific field number |
| `FieldIndex(N)` | Sequential position (1st field, 2nd field...) | Iterating ALL fields generically |

Field numbers are non-sequential — a table might have fields 
1, 2, 5, 10, 50100. `FieldIndex(3)` is the 3rd field in 
definition order, which might be field number 5, not 3.

### Real-world uses
- Generic change logging frameworks (audit trails for any table)
- Data import/export engines handling multiple table types
- Generic validation codeunits
- Copying fields between similar records (e.g., order → archive)
- Framework-style code that works across extensions without knowing their tables

### When to use RecordRef/FieldRef
✅ Building generic frameworks that must work across multiple tables  
✅ Dynamic field access where field names aren't known at compile time  
✅ Copying/comparing records of the same or similar table structure  

### When NOT to use
❌ Normal single-table business logic — use a typed Record instead  
❌ Performance-critical inner loops — RecordRef/FieldRef has overhead 
  vs typed Record access (dynamic dispatch is slower than compiled field access)  
❌ Simple data reading where you know the table — 
  typed Records are cleaner, faster, and more readable