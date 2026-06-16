codeunit 50014 "Interface Demo Runner"
{
    procedure RunComparisonDemo()
    var
        DiscountStrategyFactory: Codeunit "Discount Strategy Factory";
        IDiscountStrategy: Interface "IDiscountStrategy";
        Output: Text;
        OriginalAmount, Quantity : Decimal;
    begin
        OriginalAmount := 1000;
        Quantity := 60;

        Output := StrSubstNo(
            '=== Comparing Discount Strategies ===\Order: %1 units, $%2 total\\',
            Quantity, OriginalAmount);

        IDiscountStrategy := DiscountStrategyFactory.GetStrategy("Discount Strategy Type"::Percentage);
        Output += StrSubstNo('%1 → Discount: $%2\',
            IDiscountStrategy.GetStrategyName(),
            IDiscountStrategy.CalculateDiscount(OriginalAmount, Quantity));

        IDiscountStrategy := DiscountStrategyFactory.GetStrategy("Discount Strategy Type"::FixedAmount);
        Output += StrSubstNo('%1 → Discount: $%2\',
            IDiscountStrategy.GetStrategyName(),
            IDiscountStrategy.CalculateDiscount(OriginalAmount, Quantity));

        IDiscountStrategy := DiscountStrategyFactory.GetStrategy("Discount Strategy Type"::TieredQuantity);
        Output += StrSubstNo('%1 → Discount: $%2\',
            IDiscountStrategy.GetStrategyName(),
            IDiscountStrategy.CalculateDiscount(OriginalAmount, Quantity));

        Message(Output);
    end;

    procedure RunDynamicSwapDemo(UseTieredPricing: Boolean)
    var
        DiscountStrategyFactory: Codeunit "Discount Strategy Factory";
        IDiscountStrategy: Interface "IDiscountStrategy";
        FinalDiscount: Decimal;
    begin
        if UseTieredPricing then
            IDiscountStrategy := DiscountStrategyFactory.GetStrategy("Discount Strategy Type"::TieredQuantity)
        else
            IDiscountStrategy := DiscountStrategyFactory.GetStrategy("Discount Strategy Type"::Percentage);

        FinalDiscount := IDiscountStrategy.CalculateDiscount(500, 25);

        Message('Using "%1" → Final discount: $%2',
            IDiscountStrategy.GetStrategyName(), FinalDiscount);
    end;
}