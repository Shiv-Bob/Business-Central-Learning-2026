tableextension 50001 "Customer Loyalty Ext" extends Customer
{
    fields
    {
        field(50001; "Loyalty Tier"; Enum "Loyalty Tier")
        {
            Caption = 'Loyalty Tier';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Loyalty Tier" = "Loyalty Tier"::Gold then
                    Message('Customer %1 upgraded to Gold tier', Name);
            end;
        }
        field(50002; "Loyalty Points"; Integer)
        {
            Caption = 'Loyalty Points';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }
}