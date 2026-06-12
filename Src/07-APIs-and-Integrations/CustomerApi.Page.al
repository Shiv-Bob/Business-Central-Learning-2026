page 50001 "Customer Loyalty API"
{
    PageType = API;
    APIPublisher = 'contoso';
    APIGroup = 'loyalty';
    APIVersion = 'v1.0';
    EntityName = 'loyaltyCustomer';
    EntitySetName = 'loyaltyCustomers';
    SourceTable = Customer;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.") { Caption = 'No.'; }
                field(name; Rec.Name) { Caption = 'Name'; }
                field(loyaltyTier; Rec."Loyalty Tier") { Caption = 'Loyalty Tier'; }
                field(loyaltyPoints; Rec."Loyalty Points") { Caption = 'Loyalty Points'; }
            }
        }
    }
}