codeunit 50008 "Discount Calculator"
{
    // ─────────────────────────────────────────────────────────────
    // This codeunit shows the CONSUMER side of the cache pattern.
    //
    // It calculates discounted prices for sales lines using the
    // DiscountRulesCache — no direct DB reads for discount data.
    // ─────────────────────────────────────────────────────────────

    procedure CalculateDiscountedAmount(CustomerNo: Code[20]; UnitPrice: Decimal; Quantity: Decimal): Decimal
    var
        CustomerRec: Record Customer;
        DiscountRulesCache: Codeunit "Discount Rules Cache";
        DiscountPercent, DiscountedAmount : Decimal;
    begin
        CustomerRec.SetLoadFields("Customer Disc. Group");
        if not CustomerRec.Get(CustomerNo) then
            exit(UnitPrice * Quantity);

        // Corrected field name: "Customer Disc. Group" not "Customer Price Group"
        DiscountPercent := DiscountRulesCache.GetDiscountPercent(
            CustomerRec."Customer Disc. Group");

        DiscountedAmount := (UnitPrice * Quantity) *
            (1 - (DiscountPercent / 100));

        exit(DiscountedAmount);
    end;

    procedure ProcessAllSalesLinesForOrder(SalesHeaderNo: Code[20])
    var
        SalesLineRec: Record "Sales Line";
        DiscountRulesCache: Codeunit "Discount Rules Cache";
        TotalAmount: Decimal;
        LineCount: Integer;
    begin
        // PRELOAD all discount groups BEFORE the loop.
        // This loads everything in one DB pass, so the loop
        // itself never touches the database for discounts.
        DiscountRulesCache.PreloadAllGroups();

        SalesLineRec.SetRange("Document Type", SalesLineRec."Document Type"::Order);
        SalesLineRec.SetRange("Document No.", SalesHeaderNo);
        SalesLineRec.SetLoadFields(
            "No.", "Sell-to Customer No.", "Unit Price", Quantity);

        if SalesLineRec.FindSet() then
            repeat
                LineCount += 1;
                TotalAmount += CalculateDiscountedAmount(
                    SalesLineRec."Sell-to Customer No.",
                    SalesLineRec."Unit Price",
                    SalesLineRec.Quantity);
            until SalesLineRec.Next() = 0;

        Message(
            'Processed %1 lines.\Total discounted amount: %2\DB reads for discounts: %3',
            LineCount,
            TotalAmount,
            DiscountRulesCache.GetDatabaseReadCount());
        // ^ Notice: DB reads = 1 (PreloadAllGroups),
        //   regardless of how many lines the order has.
    end;
}