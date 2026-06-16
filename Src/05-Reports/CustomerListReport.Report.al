report 50001 "Customer List - Loyalty"
{
    ApplicationArea = All;
    Caption = 'Customer List by Loyalty Tier';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src/05-Reports/CustomerListLoyalty.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Loyalty Tier", "Country/Region Code";

            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(LoyaltyTier; "Loyalty Tier") { }
            column(LoyaltyPoints; "Loyalty Points") { }
            column(CreditLimit; "Credit Limit (LCY)") { }

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Loyalty Tier");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(MinPointsFilter; MinPoints)
                    {
                        ApplicationArea = All;
                        Caption = 'Minimum Loyalty Points';
                    }
                }
            }
        }
    }

    var
        MinPoints: Integer;
}