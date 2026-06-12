codeunit 50006 "Customer Tag Management"
{
    procedure AddTagToCustomer(CustomerNo: Code[20]; TagName: Text[50])
    var
        CustomerTag: Record "Customer Tag";
    begin
        if CustomerTag.Get(CustomerNo, TagName) then
            exit; // already tagged

        CustomerTag.Init();
        CustomerTag."Customer No." := CustomerNo;
        CustomerTag."Tag Name" := TagName;
        CustomerTag.Insert(true);
    end;

    procedure CountTagsForCustomer(CustomerNo: Code[20]): Integer
    var
        CustomerTag: Record "Customer Tag";
    begin
        CustomerTag.SetRange("Customer No.", CustomerNo);
        exit(CustomerTag.Count());
    end;
}