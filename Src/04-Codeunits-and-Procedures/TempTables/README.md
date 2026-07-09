## Temp Tables — When and How to Use Them Correctly

### What they are
A temp table is a regular AL table used as an **in-memory data 
structure**. Data inserted into it never touches the database — 
it exists only for the lifetime of the Record variable that holds it.

Two ways to create a temp table:
- `TableType = Temporary` in the table object — forces the table 
  to ONLY be usable as temp (no real database table is created)
- Declare any Record variable with the `temporary` keyword — 
  uses a real table structure but keeps this instance in memory

### Files

| File | Purpose |
|---|---|
| `SalesAnalysisBuffer` | The buffer table (`TableType = Temporary`) |
| `SalesAnalysisProcessor` | Core patterns: populate, filter, sort, modify, aggregate in memory |
| `TempTableDemoRunner` | Runnable demos + the critical var vs non-var scoping lesson |
| `TempVsRealTableComparison` | Side-by-side: repeated DB queries vs single-pass with temp table |

### Key concepts

**Always pass temp tables with `var`**
Temp table data lives inside the Record variable itself — not in 
a shared memory location. If you pass a temp table WITHOUT `var`, 
the called procedure gets an empty copy. Always use `var` to share 
the same in-memory instance across procedures.

**Always Reset + DeleteAll before repopulating**
If a temp table variable is reused or passed in from outside, it 
may already contain data. Always call `Reset()` + `DeleteAll()` 
before populating to guarantee a clean slate.

**TableType = Temporary vs `temporary` keyword**

| Approach | When to use |
|---|---|
| `TableType = Temporary` | Table is ONLY ever used as a buffer — never as a real DB table |
| `temporary` keyword on Record var | Table exists in DB normally, but THIS instance runs in memory |

### The core performance pattern
1. ONE database pass → populate temp table
2. ALL subsequent operations → in-memory (filters, sorts, aggregations)
3. Result → consumed by UI/report/API

This is far more efficient than querying the database separately 
for each different view of the same data.

### When to use temp tables
✅ Buffering data for a page/report that needs it in a specific structure  
✅ Intermediate processing — transform data before displaying or exporting  
✅ Sorting/filtering data in ways the real table's keys don't support  
✅ Passing structured datasets between codeunits without DB overhead  

### When NOT to use
❌ Simple single-pass reads — just use SetLoadFields + FindSet  
❌ Data that must persist beyond the current transaction — use a real table  
❌ Very large datasets — temp tables live in memory; 
  loading millions of rows defeats the purpose