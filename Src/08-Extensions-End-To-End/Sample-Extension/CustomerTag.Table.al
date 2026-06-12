table 50001 "Customer Tag"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Tag';

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(2; "Tag Name"; Text[50])
        {
            Caption = 'Tag Name';
        }
        field(3; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Tag Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Created Date" = 0D then
            "Created Date" := Today();
    end;
}