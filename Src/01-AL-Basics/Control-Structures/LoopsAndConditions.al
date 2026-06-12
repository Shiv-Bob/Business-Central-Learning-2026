codeunit 50002 "Loops And Conditions Demo"
{
    procedure LoopThroughCustomers()
    var
        CustomerRec: Record Customer;
        CustomerCount: Integer;
    begin
        if CustomerRec.FindSet() then
            repeat
                CustomerCount += 1;
                if CustomerRec."Credit Limit (LCY)" > 50000 then
                    Message('%1 has a high credit limit', CustomerRec.Name);
            until CustomerRec.Next() = 0;

        Message('Total customers processed: %1', CustomerCount);
    end;

    procedure CaseExample(Status: Option Open,Released,Pending)
    var
        ResultText: Text;
    begin
        case Status of
            Status::Open:
                ResultText := 'Document is still open';
            Status::Released:
                ResultText := 'Document has been released';
            Status::Pending:
                ResultText := 'Document is pending approval';
            else
                ResultText := 'Unknown status';
        end;

        Message(ResultText);
    end;
}