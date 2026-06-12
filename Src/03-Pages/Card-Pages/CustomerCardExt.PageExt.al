pageextension 50001 "Customer Card Loyalty Ext" extends "Customer Card"
{
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Loyalty Tier"; Rec."Loyalty Tier")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s loyalty tier.';
            }
            field("Loyalty Points"; Rec."Loyalty Points")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies accumulated loyalty points.';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(AddLoyaltyPoints)
            {
                ApplicationArea = All;
                Caption = 'Add 100 Loyalty Points';
                Image = AddAction;

                trigger OnAction()
                begin
                    Rec."Loyalty Points" += 100;
                    Rec.Modify(true);
                end;
            }
        }
    }
}