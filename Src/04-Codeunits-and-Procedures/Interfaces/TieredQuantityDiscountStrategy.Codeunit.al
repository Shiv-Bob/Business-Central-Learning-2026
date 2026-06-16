codeunit 50012 "TieredQuantityDiscountStrategy" implements "IDiscountStrategy"
{
    procedure CalculateDiscount(OriginalAmount: Decimal; Quantity: Decimal): Decimal
    var
        DiscountPercent: Decimal;
    begin
        // Discount tier depends on quantity ordered
        case true of
            Quantity >= 100:
                DiscountPercent := 20;
            Quantity >= 50:
                DiscountPercent := 12;
            Quantity >= 10:
                DiscountPercent := 5;
            else
                DiscountPercent := 0;
        end;

        exit(OriginalAmount * (DiscountPercent / 100));
    end;

    procedure GetStrategyName(): Text[50]
    begin
        exit('Tiered Quantity Discount (5%/12%/20%)');
    end;
}