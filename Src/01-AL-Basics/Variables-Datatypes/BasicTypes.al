codeunit 50001 "Basic Types Demo"
{
    procedure DemoVariableTypes()
    var
        SampleText: Text[50];
        SampleInteger: Integer;
        SampleDecimal: Decimal;
        SampleDate: Date;
        SampleBoolean: Boolean;
        SampleOption: Option Open,Released,Pending;
    begin
        SampleText := 'Hello Business Central';
        SampleInteger := 100;
        SampleDecimal := 99.95;
        SampleDate := Today();
        SampleBoolean := true;
        SampleOption := SampleOption::Released;

        Message('Text: %1\Integer: %2\Decimal: %3\Date: %4\Bool: %5\Option: %6',
            SampleText, SampleInteger, SampleDecimal, SampleDate, SampleBoolean, SampleOption);
    end;
}