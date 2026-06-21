## Query Objects

### What it is
A `Query` object reads and aggregates data across multiple related 
tables in a single, efficient database call — similar to a SQL JOIN. 
Queries are read-only (no Insert/Modify/Delete) but significantly 
faster than nested AL loops for reporting and analysis.

### Files

| File | Purpose |
|---|---|
| `CustomerSalesSummary` | The Query object — joins Customer → Sales Header → Sales Line |
| `QueryConsumer` | Shows how to Open/Read/Close a Query and apply filters |
| `QueryVsLoopComparison` | Side-by-side: nested loops vs Query object, same result |

### Key concepts

**DataItemLink** — defines the JOIN condition between dataitems, 
equivalent to a SQL `ON` clause.

**SqlJoinType** — `InnerJoin` excludes parent rows with no matches 
(e.g., customers with zero orders). `LeftOuterJoin` includes them 
with null/zero values — usually what you want for summary reports.

**Method = Sum / Count / Average / Min / Max** — aggregation happens 
at the database level via the generated SQL, not in AL code.

**Open() / Read() / Close()** — the lifecycle of using a Query in AL. 
`SetFilter` before `Open()` pushes filtering down to SQL too.

### Why this matters for performance

A report joining 3 tables for 100 customers:
- **Nested loops**: up to 600+ separate database round-trips
- **Query object**: 1 database round-trip, with SQL Server doing 
  the join and aggregation natively

### When to use Query objects
✅ Reporting/dashboard data spanning multiple related tables  
✅ Aggregations (sums, counts) across joined data  
✅ Read-only data analysis where performance matters  

### When NOT to use
❌ When you need to Insert/Modify/Delete — Queries are read-only  
❌ Simple single-table lookups — a filtered Record is simpler  
❌ When you need row-by-row business logic during iteration — 
  Queries are best for pure data retrieval, not processing