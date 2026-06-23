codeunit 50017 "Audit Change Logger"
{
    // ─────────────────────────────────────────────────────────────
    // This codeunit works with ANY table using RecordRef/FieldRef.
    // You never need to know which specific table you're working
    // with at compile time — it's determined at runtime.
    //
    // Real-world use: generic change logging, data validation
    // frameworks, import/export engines that handle multiple tables.
    // ─────────────────────────────────────────────────────────────

    procedure LogChangedFields(OldRecordRef: RecordRef; NewRecordRef: RecordRef)
    var
        OldFieldRef, NewFieldRef : FieldRef;
        FieldIndex: Integer;
        OldValue, NewValue, Output : Text;
    begin
        // ─────────────────────────────────────────────────────────
        // RecordRef.FieldCount — returns how many fields the table
        // has. We iterate ALL of them dynamically, regardless of
        // which table this RecordRef points to.
        // ─────────────────────────────────────────────────────────
        if OldRecordRef.Number <> NewRecordRef.Number then
            Error('Both RecordRefs must point to the same table.');

        Output := StrSubstNo('=== Changes detected in Table: %1 ===\',
            OldRecordRef.Caption);

        for FieldIndex := 1 to OldRecordRef.FieldCount do begin
            // ─────────────────────────────────────────────────────
            // FieldRef gives you access to a specific field by
            // its position index. Think of it as "column N" in
            // a result set — without knowing the column name
            // at compile time.
            // ─────────────────────────────────────────────────────
            OldFieldRef := OldRecordRef.FieldIndex(FieldIndex);
            NewFieldRef := NewRecordRef.FieldIndex(FieldIndex);

            // Skip FlowFields and system fields — they can't
            // be meaningfully compared for change detection
            if OldFieldRef.Class = FieldClass::FlowField then
                continue;

            OldValue := Format(OldFieldRef.Value);
            NewValue := Format(NewFieldRef.Value);

            if OldValue <> NewValue then
                Output += StrSubstNo(
                    '  Field "%1": "%2" → "%3"\',
                    OldFieldRef.Caption,
                    OldValue,
                    NewValue);
        end;

        Message(Output);
    end;

    procedure GetFieldValueAsText(RecordRefParam: RecordRef; FieldNo: Integer): Text
    var
        FieldRefVar: FieldRef;
    begin
        // ─────────────────────────────────────────────────────────
        // Field() takes a field NUMBER (not index position).
        // Field numbers are the ones defined in the table object
        // (e.g., field(1; "No."; Code[20]) → FieldNo = 1).
        // FieldIndex() takes a sequential position (1, 2, 3...).
        // These are NOT the same thing — a table's field numbers
        // are often non-sequential (1, 2, 5, 10, 50100...).
        // ─────────────────────────────────────────────────────────
        FieldRefVar := RecordRefParam.Field(FieldNo);
        exit(Format(FieldRefVar.Value));
    end;

    procedure SetFieldValue(var RecordRefParam: RecordRef; FieldNo: Integer; NewValue: Variant)
    var
        FieldRefVar: FieldRef;
    begin
        // ─────────────────────────────────────────────────────────
        // You can also WRITE to a field dynamically using FieldRef.
        // This is how generic import engines work — they read a
        // mapping (field number → value) and apply it to any record
        // without knowing the table structure at compile time.
        // ─────────────────────────────────────────────────────────
        FieldRefVar := RecordRefParam.Field(FieldNo);
        FieldRefVar.Value := NewValue;
    end;
}