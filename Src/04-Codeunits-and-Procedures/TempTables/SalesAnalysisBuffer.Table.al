table 50002 "Sales Analysis Buffer"
{
    // ─────────────────────────────────────────────────────────────
    // TableType = Temporary means this table ONLY exists as a
    // temp table — it cannot be instantiated as a real database
    // table. BC enforces this at the platform level.
    //
    // Use this when the table's SOLE purpose is as an in-memory
    // buffer. If you want a table that CAN be used both ways
    // (real or temp depending on context), omit TableType and
    // declare the Record variable with "temporary" keyword instead.
    // ─────────────────────────────────────────────────────────────
    TableType = Temporary;
    DataClassification = SystemMetadata;
    Caption = 'Sales Analysis Buffer';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(6; "Line Count"; Integer)
        {
            Caption = 'Line Count';
        }
        field(7; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
        }
        field(8; "Customer Group"; Code[20])
        {
            Caption = 'Customer Group';
        }
    }

    keys
    {
        key(PK; "Customer No.", "Document No.")
        {
            Clustered = true;
        }
        key(AmountKey; "Total Amount")
        {
        }
    }
}