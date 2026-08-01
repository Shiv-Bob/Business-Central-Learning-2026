codeunit 50021 "Temp Table Demo Runner"
{
    procedure RunFullDemo()
    var
        SalesAnalysisBufferRec: Record "Sales Analysis Buffer";
        SalesAnalysisProcessor: Codeunit "Sales Analysis Processor";
        Output: Text;
    begin
        // ─────────────────────────────────────────────────────────
        // Step 1: Populate the temp table from real sales data
        // ─────────────────────────────────────────────────────────
        SalesAnalysisProcessor.PopulateAnalysisBuffer(SalesAnalysisBufferRec, CalcDate('<-1Y>', Today()), Today());

        // ─────────────────────────────────────────────────────────
        // Step 2: Process in memory — no more DB calls needed
        // ─────────────────────────────────────────────────────────
        SalesAnalysisProcessor.UpdateBufferWithDiscountFlag(SalesAnalysisBufferRec, 500);

        // Step 3: Read results in different ways from the same data
        Output := SalesAnalysisProcessor.GetTopCustomersByAmount(SalesAnalysisBufferRec, 5);

        Message(Output);

        // ─────────────────────────────────────────────────────────
        // Step 4: Temp table is automatically cleaned up when
        // SalesAnalysisBufferRec goes out of scope — no manual
        // cleanup needed, no leftover data in the database.
        // ─────────────────────────────────────────────────────────
    end;

    procedure DemoTempTableScope()
    var
        SalesAnalysisBufferRec: Record "Sales Analysis Buffer";
    begin
        // ─────────────────────────────────────────────────────────
        // KEY CONCEPT: Temp table data is LOCAL to this variable.
        //
        // If you pass it to another procedure WITHOUT "var",
        // that procedure gets its own COPY — changes don't come back.
        // Always pass temp tables with "var" to share the same
        // in-memory instance across procedures.
        // ─────────────────────────────────────────────────────────
        SalesAnalysisBufferRec.Init();
        SalesAnalysisBufferRec."Customer No." := 'C001';
        SalesAnalysisBufferRec."Total Amount" := 1000;
        SalesAnalysisBufferRec.Insert();

        // Correct: pass by var — same in-memory instance
        ReadTempDataByRef(SalesAnalysisBufferRec);

        // Wrong pattern (shown here for contrast — don't do this):
        // ReadTempDataByValue(SalesAnalysisBufferRec);
        // → The called procedure gets a COPY with ZERO records
        //   because temp data doesn't transfer on value copy.
    end;

    local procedure ReadTempDataByRef(var SalesAnalysisBufferRec: Record "Sales Analysis Buffer")
    begin
        // Has access to the same in-memory records
        SalesAnalysisBufferRec.Reset();
        if SalesAnalysisBufferRec.FindSet() then
            Message('By ref — Found %1 records. First: %2', SalesAnalysisBufferRec.Count(), SalesAnalysisBufferRec."Customer No.");
    end;
}