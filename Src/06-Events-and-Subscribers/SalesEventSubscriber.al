codeunit 50003 "Sales Posting Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if Customer.Get(SalesHeader."Sell-to Customer No.") then begin
            Customer."Loyalty Points" += Round(SalesHeader.Amount / 100, 1);
            Customer.Modify(true);
        end;
    end;
}