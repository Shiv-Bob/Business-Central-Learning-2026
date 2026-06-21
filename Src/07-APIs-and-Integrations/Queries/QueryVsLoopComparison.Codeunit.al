codeunit 50016 "Query Vs Loop Comparison"
{
    // ─────────────────────────────────────────────────────────────
    // This codeunit shows the SAME result computed two ways:
    // 1. The traditional nested-loop approach (what most devs write)
    // 2. The Query object approach (what senior devs write)
    //
    // Both produce the same answer. The difference is HOW MANY
    // database round-trips each approach makes.
    // ─────────────────────────────────────────────────────────────

    procedure CalculateUsingNestedLoops(): Decimal
    var
        CustomerRec: Record Customer;
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        GrandTotal: Decimal;
    begin
        // ── Approach 1: Nested loops ──
        // For every customer, query Sales Header.
        // For every Sales Header, query Sales Line.
        // With 100 customers × 5 orders each = 100 + 500 = 600
        // separate database calls.

        CustomerRec.SetLoadFields("No.");
        if CustomerRec.FindSet() then
            repeat
                SalesHeaderRec.SetRange("Sell-to Customer No.", CustomerRec."No.");
                SalesHeaderRec.SetLoadFields("No.", "Document Type");

                if SalesHeaderRec.FindSet() then
                    repeat
                        SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                        SalesLineRec.SetRange("Document Type", SalesHeaderRec."Document Type");
                        SalesLineRec.SetLoadFields(Amount);
                        SalesLineRec.CalcSums(Amount);

                        GrandTotal += SalesLineRec.Amount;
                    until SalesHeaderRec.Next() = 0;

            until CustomerRec.Next() = 0;

        exit(GrandTotal);
    end;

    procedure CalculateUsingQuery(): Decimal
    var
        CustomerSalesSummary: Query "Customer Sales Summary";
        GrandTotal: Decimal;
    begin
        // ── Approach 2: Query object ──
        // ONE database call. The join and aggregation both
        // happen inside SQL Server, not in AL.

        CustomerSalesSummary.Open();

        while CustomerSalesSummary.Read() do
            GrandTotal += CustomerSalesSummary.LineAmount;

        CustomerSalesSummary.Close();

        exit(GrandTotal);
    end;
}