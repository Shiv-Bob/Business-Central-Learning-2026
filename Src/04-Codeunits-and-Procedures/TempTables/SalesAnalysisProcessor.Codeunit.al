codeunit 50020 "Sales Analysis Processor"
{
    // ─────────────────────────────────────────────────────────────
    // This codeunit shows the most important temp table patterns:
    // 1. Populating a temp table from real data
    // 2. Processing/aggregating in memory
    // 3. Passing temp tables between procedures
    // 4. Sorting and filtering temp data
    // ─────────────────────────────────────────────────────────────

    procedure PopulateAnalysisBuffer(var SalesAnalysisBufferRec: Record "Sales Analysis Buffer"; FromDate: Date; ToDate: Date)
    var
        CustomerRec: Record Customer;
        SalesLineRec: Record "Sales Line";
        SalesHeaderRec: Record "Sales Header";
    begin
        // ─────────────────────────────────────────────────────────
        // Always clear the temp table before populating.
        // Since it's passed by var, it may already have data
        // from a previous call — Reset + DeleteAll ensures
        // we start fresh every time.
        // ─────────────────────────────────────────────────────────
        SalesAnalysisBufferRec.Reset();
        SalesAnalysisBufferRec.DeleteAll();

        SalesHeaderRec.SetRange("Document Type", SalesHeaderRec."Document Type"::Order);
        SalesHeaderRec.SetRange("Order Date", FromDate, ToDate);
        SalesHeaderRec.SetLoadFields("No.", "Sell-to Customer No.", "Order Date");

        if not SalesHeaderRec.FindSet() then
            exit;

        repeat
            // ─────────────────────────────────────────────────────
            // Aggregate Sales Lines for this header in memory.
            // We're doing the heavy lifting ONCE per header,
            // then storing the result in the temp table —
            // rather than re-querying lines every time we need them.
            // ─────────────────────────────────────────────────────
            SalesLineRec.SetRange("Document Type", SalesHeaderRec."Document Type");
            SalesLineRec.SetRange("Document No.", SalesHeaderRec."No.");
            SalesLineRec.SetLoadFields(Amount, "Line Discount Amount");
            SalesLineRec.CalcSums(Amount, "Line Discount Amount");

            CustomerRec.SetLoadFields(Name, "Customer Disc. Group");
            if not CustomerRec.Get(SalesHeaderRec."Sell-to Customer No.") then
                Clear(CustomerRec);

            // ─────────────────────────────────────────────────────
            // Insert into temp table — works exactly like a real
            // table Insert, but goes to memory, not the database.
            // ─────────────────────────────────────────────────────
            SalesAnalysisBufferRec.Init();
            SalesAnalysisBufferRec."Customer No." := SalesHeaderRec."Sell-to Customer No.";
            SalesAnalysisBufferRec."Customer Name" := CustomerRec.Name;
            SalesAnalysisBufferRec."Document No." := SalesHeaderRec."No.";
            SalesAnalysisBufferRec."Posting Date" := SalesHeaderRec."Order Date";
            SalesAnalysisBufferRec."Total Amount" := SalesLineRec.Amount;
            SalesAnalysisBufferRec."Discount Amount" := SalesLineRec."Line Discount Amount";
            SalesAnalysisBufferRec."Line Count" := SalesLineRec.Count();
            SalesAnalysisBufferRec."Customer Group" := CustomerRec."Customer Disc. Group";
            SalesAnalysisBufferRec.Insert();

        until SalesHeaderRec.Next() = 0;
    end;

    procedure GetTopCustomersByAmount(var SalesAnalysisBufferRec: Record "Sales Analysis Buffer"; TopN: Integer): Text
    var
        Output: Text;
        RowCount: Integer;
    begin
        // ─────────────────────────────────────────────────────────
        // Sorting temp tables is a huge benefit — you can sort
        // by any key you defined without hitting the database again.
        // Here we sort by Total Amount descending to get top customers.
        // ─────────────────────────────────────────────────────────
        SalesAnalysisBufferRec.Reset();
        SalesAnalysisBufferRec.SetCurrentKey("Total Amount");
        SalesAnalysisBufferRec.Ascending(false);

        Output := StrSubstNo('=== Top %1 Customers by Sales Amount ===\', TopN);

        if SalesAnalysisBufferRec.FindSet() then
            repeat
                RowCount += 1;
                Output += StrSubstNo('%1. %2 → $%3\',
                    RowCount,
                    SalesAnalysisBufferRec."Customer Name",
                    SalesAnalysisBufferRec."Total Amount");
            until (SalesAnalysisBufferRec.Next() = 0) or (RowCount >= TopN);

        exit(Output);
    end;

    procedure GetTotalByCustomerGroup(
        var SalesAnalysisBufferRec: Record "Sales Analysis Buffer";
        CustomerGroup: Code[20]): Decimal
    var
        GroupTotal: Decimal;
    begin
        // ─────────────────────────────────────────────────────────
        // Filtering a temp table works exactly like filtering a
        // real Record — SetRange, SetFilter, FindSet, etc.
        // The difference: this filter operates on IN-MEMORY data,
        // not the database. No SQL query is generated.
        // ─────────────────────────────────────────────────────────
        SalesAnalysisBufferRec.Reset();
        SalesAnalysisBufferRec.SetRange("Customer Group", CustomerGroup);
        SalesAnalysisBufferRec.CalcSums("Total Amount");
        GroupTotal := SalesAnalysisBufferRec."Total Amount";
        SalesAnalysisBufferRec.Reset();

        exit(GroupTotal);
    end;

    procedure UpdateBufferWithDiscountFlag(
        var SalesAnalysisBufferRec: Record "Sales Analysis Buffer";
        DiscountThreshold: Decimal)
    var
        HighDiscountBufferRec: Record "Sales Analysis Buffer";
    begin
        // ─────────────────────────────────────────────────────────
        // You can MODIFY records in a temp table just like a real
        // table — Modify() works the same way, but only affects
        // the in-memory copy. Original database is untouched.
        // ─────────────────────────────────────────────────────────
        SalesAnalysisBufferRec.Reset();
        SalesAnalysisBufferRec.SetFilter("Discount Amount", '>%1', DiscountThreshold);

        if SalesAnalysisBufferRec.FindSet(true) then
            repeat
                SalesAnalysisBufferRec."Customer Name" := '⚠ ' + SalesAnalysisBufferRec."Customer Name";
                SalesAnalysisBufferRec.Modify();
            until SalesAnalysisBufferRec.Next() = 0;

        SalesAnalysisBufferRec.Reset();
    end;
}