codeunit 50015 "Query Consumer Demo"
{
    procedure GetTotalSalesForAllCustomers(): Text
    var
        CustomerSalesSummary: Query "Customer Sales Summary";
        Output: Text;
    begin
        // ─────────────────────────────────────────────────────────
        // .Open() runs the underlying SQL query ONCE.
        // .Read() advances to the next result row, like Next()
        // on a Record — but the join/aggregation already happened
        // at the database level before this loop even starts.
        // ─────────────────────────────────────────────────────────
        CustomerSalesSummary.Open();

        while CustomerSalesSummary.Read() do
            Output += StrSubstNo(
                '%1 (%2) → Total Sales: %3\',
                CustomerSalesSummary.CustomerName,
                CustomerSalesSummary.CustomerNo,
                CustomerSalesSummary.LineAmount);

        CustomerSalesSummary.Close();

        exit(Output);
    end;

    procedure GetTotalSalesForCustomer(CustomerNo: Code[20]): Decimal
    var
        CustomerSalesSummary: Query "Customer Sales Summary";
        TotalSales: Decimal;
    begin
        // ─────────────────────────────────────────────────────────
        // SetFilter on a Query works the same way as on a Record —
        // filters get pushed down to the SQL WHERE clause.
        // ─────────────────────────────────────────────────────────
        CustomerSalesSummary.SetFilter(CustomerNo, CustomerNo);
        CustomerSalesSummary.Open();

        while CustomerSalesSummary.Read() do
            TotalSales += CustomerSalesSummary.LineAmount;

        CustomerSalesSummary.Close();

        exit(TotalSales);
    end;
}