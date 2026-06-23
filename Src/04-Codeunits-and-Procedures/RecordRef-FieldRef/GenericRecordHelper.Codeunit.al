codeunit 50018 "Generic Record Helper"
{
    // ─────────────────────────────────────────────────────────────
    // RecordRef lets you work with records generically —
    // open any table, find records, read fields, copy between
    // tables — all without compile-time knowledge of the table.
    // ─────────────────────────────────────────────────────────────

    procedure CountRecordsInTable(TableNo: Integer): Integer
    var
        RecordRefVar: RecordRef;
    begin
        // ─────────────────────────────────────────────────────────
        // Open() takes a table number and points the RecordRef
        // at that table. From here you can filter, find, count,
        // iterate — same as a normal Record variable.
        // ─────────────────────────────────────────────────────────
        RecordRefVar.Open(TableNo);
        exit(RecordRefVar.Count());
    end;

    procedure PrintAllFieldNamesForTable(TableNo: Integer)
    var
        RecordRefVar: RecordRef;
        FieldRefVar: FieldRef;
        FieldIndex: Integer;
        Output: Text;
    begin
        // Useful for debugging/inspection — lists every field
        // name and its current data type for any table at runtime
        RecordRefVar.Open(TableNo);

        Output := StrSubstNo(
            'Table %1 "%2" has %3 fields:\',
            TableNo,
            RecordRefVar.Caption,
            RecordRefVar.FieldCount);

        for FieldIndex := 1 to RecordRefVar.FieldCount do begin
            FieldRefVar := RecordRefVar.FieldIndex(FieldIndex);
            Output += StrSubstNo('  [%1] %2 (%3)\',
                FieldRefVar.Number,
                FieldRefVar.Caption,
                FieldRefVar.Type);
        end;

        Message(Output);
        RecordRefVar.Close();
    end;

    procedure CopyFieldsBetweenRecords(SourceRecordRef: RecordRef; var TargetRecordRef: RecordRef; FieldNos: List of [Integer])
    var
        SourceFieldRef, TargetFieldRef : FieldRef;
        FieldNo: Integer;
    begin
        // ─────────────────────────────────────────────────────────
        // Copy specific fields from one record to another,
        // even if they're different table types — as long as
        // the field numbers and types are compatible.
        //
        // Real-world use: copying header fields from a Sales Order
        // to a custom staging/archive table generically.
        // ─────────────────────────────────────────────────────────
        foreach FieldNo in FieldNos do begin
            SourceFieldRef := SourceRecordRef.Field(FieldNo);
            TargetFieldRef := TargetRecordRef.Field(FieldNo);
            TargetFieldRef.Value := SourceFieldRef.Value;
        end;
    end;

    procedure FindRecordByPrimaryKey(TableNo: Integer; PrimaryKeyValue: Text): Boolean
    var
        RecordRefVar: RecordRef;
        KeyRefVar: KeyRef;
        FieldRefVar: FieldRef;
    begin
        // ─────────────────────────────────────────────────────────
        // KeyRef gives you access to a table's keys dynamically.
        // KeyRef(1) = the primary key.
        // KeyRef.FieldCount = how many fields make up that key.
        // ─────────────────────────────────────────────────────────
        RecordRefVar.Open(TableNo);

        KeyRefVar := RecordRefVar.KeyIndex(1); // primary key
        if KeyRefVar.FieldCount = 1 then begin
            FieldRefVar := KeyRefVar.FieldIndex(1);
            FieldRefVar.SetRange(PrimaryKeyValue);
        end;

        exit(RecordRefVar.FindFirst());
    end;
}