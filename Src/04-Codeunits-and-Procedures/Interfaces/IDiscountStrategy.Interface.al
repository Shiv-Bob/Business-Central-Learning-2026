interface "IDiscountStrategy"
{
    // ─────────────────────────────────────────────────────────────
    // An Interface defines WHAT must be implemented, not HOW.
    // No procedure bodies here — just signatures.
    //
    // Any codeunit that "implements" this interface MUST provide
    // its own version of CalculateDiscount and GetStrategyName.
    // ─────────────────────────────────────────────────────────────

    procedure CalculateDiscount(OriginalAmount: Decimal; Quantity: Decimal): Decimal;

    procedure GetStrategyName(): Text[50];
}