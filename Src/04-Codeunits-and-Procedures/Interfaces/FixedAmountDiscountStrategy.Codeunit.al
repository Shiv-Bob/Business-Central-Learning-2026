codeunit 50011 "Fixed Amount Discount Strategy" implements "IDiscountStrategy"
{
    procedure CalculateDiscount(OriginalAmount: Decimal; Quantity: Decimal): Decimal
    var
        FixedDiscount: Decimal;
    begin
        FixedDiscount := 50; // flat currency amount off, regardless of total
        if OriginalAmount < FixedDiscount then
            exit(OriginalAmount); // can't discount more than the total
        exit(FixedDiscount);
    end;

    procedure GetStrategyName(): Text[50]
    begin
        exit('Fixed Amount Discount ($50)');
    end;
}