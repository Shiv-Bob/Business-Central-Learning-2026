## SingleInstance Codeunit Pattern

### What it is
A codeunit with `SingleInstance = true` is created ONCE per user 
session. Its global variables retain their values across all calls 
within that session — unlike a normal codeunit which resets on every call.

### What this example demonstrates

| File | Purpose |
|---|---|
| `DiscountRulesCache` | SingleInstance cache — loads discount rules once, serves from memory |
| `DiscountCalculator` | Consumer — uses cache in real business logic (sales line processing) |
| `SingleInstanceProofDemo` | Runnable proof — proves DB is read once and instance is shared |

### The three key concepts

**1. Lazy loading** — data loads on first request, not upfront.  
First call hits DB. Every call after → memory only.

**2. Preloading** — for batch processing, load everything upfront  
in one DB query before the loop starts.

**3. Cache invalidation** — the most important part.  
Always invalidate after the underlying data changes.  
Two levels: full invalidation or per-group targeted invalidation.

### When to use SingleInstance
✅ Caching setup/config data read repeatedly in one session  
✅ Caching lookup data used across many lines (discounts, tax rates)  
✅ Session-level counters or accumulators  
✅ Central service/facade used by multiple codeunits  

### When NOT to use
❌ Data that changes frequently mid-session without invalidation  
❌ Large datasets — keep cached data small and targeted  
❌ As a substitute for proper database query design  

### Performance proof
A Sales Order with 50 lines, 3 customer price groups:
- Without cache → 50 DB reads (one per line)
- With lazy loading → 3 DB reads (one per unique group)  
- With PreloadAllGroups → 1 DB read (everything upfront)