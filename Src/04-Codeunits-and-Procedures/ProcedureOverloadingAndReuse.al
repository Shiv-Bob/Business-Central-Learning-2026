codeunit 50004 "Procedure Patterns Demo"
{
    // Pattern: Function with optional parameters via overload-style procedures
    procedure CalculateDiscount(Amount: Decimal; DiscountPercent: Decimal): Decimal
    begin
        exit(Amount - (Amount * DiscountPercent / 100));
    end;

    procedure CalculateDiscountWithMinimum(Amount: Decimal; DiscountPercent: Decimal; MinimumOrderAmount: Decimal): Decimal
    begin
        if Amount < MinimumOrderAmount then
            exit(Amount);
        exit(CalculateDiscount(Amount, DiscountPercent));
    end;

    // Pattern: Returning a Boolean + var parameter for "out" style results
    procedure TryGetCustomerDiscount(CustomerNo: Code[20]; var DiscountPercent: Decimal): Boolean
    var
        CustomerDiscGroup: Record "Customer Discount Group";
        Customer: Record Customer;
    begin
        if not Customer.Get(CustomerNo) then
            exit(false);

        if Customer."Customer Disc. Group" = '' then
            exit(false);

        DiscountPercent := 10; // simplified for demo
        exit(true);
    end;
}