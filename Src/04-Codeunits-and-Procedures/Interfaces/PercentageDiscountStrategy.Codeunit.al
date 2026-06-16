codeunit 50010 "Percentage Discount Strategy" implements "IDiscountStrategy"
{
    // ─────────────────────────────────────────────────────────────
    // "implements IDiscountStrategy" means this codeunit MUST
    // provide every procedure declared in the interface, with
    // matching signatures. The compiler enforces this.
    // ─────────────────────────────────────────────────────────────

    procedure CalculateDiscount(OriginalAmount: Decimal; Quantity: Decimal): Decimal
    var
        DiscountPercent: Decimal;
    begin
        DiscountPercent := 10; // flat 10% for this example
        exit(OriginalAmount * (DiscountPercent / 100));
    end;

    procedure GetStrategyName(): Text[50]
    begin
        exit('Percentage Discount (10%)');
    end;
}