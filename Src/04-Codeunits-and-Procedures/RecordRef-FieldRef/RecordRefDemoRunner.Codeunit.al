codeunit 50019 "RecordRef Demo Runner"
{
    procedure DemoChangeDetection()
    var
        CustomerRec: Record Customer;
        AuditChangeLogger: Codeunit "Audit Change Logger";
        OldRecordRef: RecordRef;
        NewRecordRef: RecordRef;
    begin
        // ─────────────────────────────────────────────────────────
        // GetTable() converts a typed Record variable into a
        // RecordRef — the bridge between specific and generic.
        // ─────────────────────────────────────────────────────────
        if not CustomerRec.FindFirst() then begin
            Message('No customers found in this company.');
            exit;
        end;

        // Capture the "before" state
        OldRecordRef.GetTable(CustomerRec);

        // Simulate a change
        NewRecordRef.GetTable(CustomerRec);
        AuditChangeLogger.SetFieldValue(
            NewRecordRef, CustomerRec.FieldNo(Name), 'Updated Customer Name');
        AuditChangeLogger.SetFieldValue(
            NewRecordRef, CustomerRec.FieldNo("Credit Limit (LCY)"), 99999);

        // Compare old vs new — works for ANY table
        AuditChangeLogger.LogChangedFields(OldRecordRef, NewRecordRef);
    end;

    procedure DemoTableInspection()
    var
        GenericRecordHelper: Codeunit "Generic Record Helper";
    begin
        // ─────────────────────────────────────────────────────────
        // Pass any table number — 18 = Customer, 23 = Vendor,
        // 27 = Item. The same code works for all of them.
        // ─────────────────────────────────────────────────────────
        Message('=== Customer Table (18) ===');
        GenericRecordHelper.PrintAllFieldNamesForTable(18);

        Message('=== Vendor Table (23) ===');
        GenericRecordHelper.PrintAllFieldNamesForTable(23);
    end;

    procedure DemoRecordCount()
    var
        GenericRecordHelper: Codeunit "Generic Record Helper";
        Output: Text;
    begin
        // Count records in multiple tables without separate
        // Record variables for each — one generic procedure handles all
        Output := 'Record counts:\';
        Output += StrSubstNo('  Customers: %1\',
            GenericRecordHelper.CountRecordsInTable(18));
        Output += StrSubstNo('  Vendors: %1\',
            GenericRecordHelper.CountRecordsInTable(23));
        Output += StrSubstNo('  Items: %1\',
            GenericRecordHelper.CountRecordsInTable(27));

        Message(Output);
    end;

    procedure DemoFieldCopy()
    var
        CustomerRec: Record Customer;
        GenericRecordHelper: Codeunit "Generic Record Helper";
        AuditChangeLogger: Codeunit "Audit Change Logger";
        SourceRecordRef: RecordRef;
        TargetRecordRef: RecordRef;
        FieldsToCopy: List of [Integer];
    begin
        // Copy specific fields from one Customer record to another
        if not CustomerRec.FindFirst() then
            exit;

        SourceRecordRef.GetTable(CustomerRec);

        // Point target at a new empty Customer record
        CustomerRec.Init();
        TargetRecordRef.GetTable(CustomerRec);

        // Copy just Name (field 2) and Address (field 5)
        FieldsToCopy.Add(2);
        FieldsToCopy.Add(5);

        GenericRecordHelper.CopyFieldsBetweenRecords(
            SourceRecordRef, TargetRecordRef, FieldsToCopy);

        Message('Fields copied. Name: %1, Address: %2',
            AuditChangeLogger.GetFieldValueAsText(TargetRecordRef, 2),
            AuditChangeLogger.GetFieldValueAsText(TargetRecordRef, 5));
    end;
}