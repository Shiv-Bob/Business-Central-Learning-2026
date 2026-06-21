query 50001 "Customer Sales Summary"
{
    QueryType = Normal;
    Caption = 'Customer Sales Summary';

    elements
    {
        dataitem(Customer; Customer)
        {
            column(CustomerNo; "No.")
            {
            }
            column(CustomerName; Name)
            {
            }
            column(CustomerDiscGroup; "Customer Disc. Group")
            {
            }

            dataitem(SalesHeader; "Sales Header")
            {
                DataItemLink = "Sell-to Customer No." = Customer."No.";
                SqlJoinType = LeftOuterJoin;

                column(DocumentNo; "No.")
                {
                }
                column(OrderDate; "Order Date")
                {
                }

                dataitem(SalesLine; "Sales Line")
                {
                    DataItemLink = "Document No." = SalesHeader."No.", "Document Type" = SalesHeader."Document Type";
                    SqlJoinType = LeftOuterJoin;

                    column(LineAmount; Amount)
                    {
                        Method = Sum;
                    }
                }
            }
        }
    }
}