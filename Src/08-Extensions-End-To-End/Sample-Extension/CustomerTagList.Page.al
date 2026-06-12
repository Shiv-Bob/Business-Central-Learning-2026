page 50002 "Customer Tag List"
{
    PageType = List;
    SourceTable = "Customer Tag";
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Customer Tags';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Tag Name"; Rec."Tag Name")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}