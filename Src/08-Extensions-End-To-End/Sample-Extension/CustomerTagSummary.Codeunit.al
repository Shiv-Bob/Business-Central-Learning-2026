codeunit 50006 "Customer Tag Management"
{
    procedure AddTagToCustomer(CustomerNo: Code[20]; TagName: Text[50])
    var
        CustomerTagRec: Record "Customer Tag";
    begin
        if CustomerTagRec.Get(CustomerNo, TagName) then
            exit; // already tagged

        CustomerTagRec.Init();
        CustomerTagRec."Customer No." := CustomerNo;
        CustomerTagRec."Tag Name" := TagName;
        CustomerTagRec.Insert(true);
    end;

    procedure CountTagsForCustomer(CustomerNo: Code[20]): Integer
    var
        CustomerTagRec: Record "Customer Tag";
    begin
        CustomerTagRec.SetRange("Customer No.", CustomerNo);
        exit(CustomerTagRec.Count());
    end;
}