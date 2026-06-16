enum 50002 "Discount Strategy Type"
{
    Extensible = true;

    value(0; Percentage) { Caption = 'Percentage'; }
    value(1; FixedAmount) { Caption = 'Fixed Amount'; }
    value(2; TieredQuantity) { Caption = 'Tiered Quantity'; }
}