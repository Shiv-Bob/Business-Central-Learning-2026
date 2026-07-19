codeunit 50022 "Temp Vs Real Table Comparison"
{
    // ─────────────────────────────────────────────────────────────
    // This codeunit shows the same data processing task done:
    // 1. Without temp table — multiple repeated DB queries
    // 2. With temp table — load once, process many times in memory
    // ─────────────────────────────────────────────────────────────

    procedure ProcessWithoutTempTable(CustomerGroup: Code[20])
    var
        SalesHeaderRec: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
        CustomerRec: Record Customer;
        TopCustomer: Text;
        GroupTotal, TopAmount, CustomerTotal : Decimal;
    begin
        // ── PASS 1: Calculate group total ──
        // This queries Sales Header + Sales Line from database
        SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
        if SalesHeaderRec.FindSet() then
            repeat
                if CustomerRec.Get(SalesHeaderRec."Sell-to Customer No.") then
                    if CustomerRec."Customer Disc. Group" = CustomerGroup then begin
                        SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                        SalesLineRec.CalcSums(Amount);
                        GroupTotal += SalesLineRec.Amount;
                    end;
            until SalesHeaderRec.Next() = 0;

        // ── PASS 2: Find top customer ──
        // Queries the SAME data from database AGAIN for a different purpose
        SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
        if SalesHeaderRec.FindSet() then
            repeat
                if CustomerRec.Get(SalesHeaderRec."Sell-to Customer No.") then
                    if CustomerRec."Customer Disc. Group" = CustomerGroup then begin
                        SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
                        SalesLineRec.CalcSums(Amount);
                        CustomerTotal := SalesLineRec.Amount;
                        if CustomerTotal > TopAmount then begin
                            TopAmount := CustomerTotal;
                            TopCustomer := CustomerRec.Name;
                        end;
                    end;
            until SalesHeaderRec.Next() = 0;

        // Two full database scans for the same data — wasteful
        Message('Group Total: %1\Top Customer: %2 ($%3)', GroupTotal, TopCustomer, TopAmount);
    end;

    procedure ProcessWithTempTable(CustomerGroup: Code[20])
    var
        SalesAnalysisBufferRec: Record "Sales Analysis Buffer";
        SalesAnalysisProcessor: Codeunit "Sales Analysis Processor";
        GroupTotal: Decimal;
        Output: Text;
    begin
        // ── ONE database pass to populate the temp table ──
        SalesAnalysisProcessor.PopulateAnalysisBuffer(SalesAnalysisBufferRec, CalcDate('<-1Y>', Today()), Today());

        // ── ALL subsequent processing hits memory, not database ──

        // Get group total — in memory
        GroupTotal := SalesAnalysisProcessor.GetTotalByCustomerGroup(SalesAnalysisBufferRec, CustomerGroup);

        // Get top customers — in memory, different sort
        Output := SalesAnalysisProcessor.GetTopCustomersByAmount(SalesAnalysisBufferRec, 3);

        // Apply flags — in memory
        SalesAnalysisProcessor.UpdateBufferWithDiscountFlag(SalesAnalysisBufferRec, 500);

        // One database scan. Three different operations on the same data.
        Message('Group Total: %1\\%2', GroupTotal, Output);
    end;
}