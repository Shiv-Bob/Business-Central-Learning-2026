## Interfaces (Polymorphism in AL)

### What it is
An Interface defines a contract — method signatures with no 
implementation. Any codeunit can implement it using the 
`implements "InterfaceName"` syntax. AL enforces at compile time 
that every interface method is implemented.

### Files

| File | Purpose |
|---|---|
| `IDiscountStrategy` | The interface contract |
| `PercentageDiscountStrategy` | Implementation 1 — % off |
| `FixedAmountDiscountStrategy` | Implementation 2 — flat amount off |
| `TieredQuantityDiscountStrategy` | Implementation 3 — quantity-based tiers |
| `DiscountStrategyFactory` | Returns the right implementation based on a parameter |
| `InterfaceDemoRunner` | Proves swapping implementations works seamlessly |
| `DiscountStrategyType` | Enum used to select which strategy implementation to retrieve from the factory |

### Why this matters

Without interfaces, choosing between strategies usually means a 
big `case` statement scattered across the codebase, checked 
everywhere the logic is needed. With interfaces:

- Calling code only knows about the interface, never the 
  concrete implementation
- Adding a new strategy means adding one new codeunit + one 
  factory case — zero changes to existing calling code
- Each implementation can be unit-tested independently
- Other extensions can provide their OWN implementation of your 
  interface, extending your logic without modifying it

### Real BC example
Microsoft's Tax Engine uses this exact pattern — different tax 
calculation strategies (GST, VAT, Sales Tax) all implement a 
shared interface, and the posting engine calls the interface 
without knowing which country's logic is running.

### When to use
✅ Multiple interchangeable strategies for the same operation  
✅ You want other extensions to plug in custom behavior  
✅ Writing testable code (swap in a mock implementation for tests)

### When NOT to use
❌ Only one implementation exists and none are planned — adds 
unnecessary complexity