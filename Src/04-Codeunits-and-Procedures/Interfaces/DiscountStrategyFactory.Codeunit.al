codeunit 50013 "Discount Strategy Factory"
{
    procedure GetStrategy(DiscountStrategyType: Enum "Discount Strategy Type"): Interface "IDiscountStrategy"
    var
        PercentageDiscountStrategy: Codeunit "Percentage Discount Strategy";
        FixedAmountDiscountStrategy: Codeunit "Fixed Amount Discount Strategy";
        TieredQuantityDiscountStrategy: Codeunit "TieredQuantityDiscountStrategy";
    begin
        case DiscountStrategyType of
            DiscountStrategyType::Percentage:
                exit(PercentageDiscountStrategy);
            DiscountStrategyType::FixedAmount:
                exit(FixedAmountDiscountStrategy);
            DiscountStrategyType::TieredQuantity:
                exit(TieredQuantityDiscountStrategy);
        end;
    end;
}