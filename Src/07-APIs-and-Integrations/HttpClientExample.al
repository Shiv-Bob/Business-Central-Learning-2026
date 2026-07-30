codeunit 50005 "External API Client Demo"
{
    procedure GetExchangeRate(CurrencyCode: Text): Decimal
    var
        Client: HttpClient;
        HttpResponse: HttpResponseMessage;
        JsonResponse: JsonObject;
        JToken: JsonToken;
        RequestUrl, ResponseText : Text;
    begin
        RequestUrl := StrSubstNo('https://api.exchangerate.example/latest?base=%1', CurrencyCode);

        if not Client.Get(RequestUrl, HttpResponse) then
            Error('Failed to call exchange rate API');

        if not HttpResponse.IsSuccessStatusCode() then
            Error('API returned error: %1', HttpResponse.HttpStatusCode());

        HttpResponse.Content().ReadAs(ResponseText);
        JsonResponse.ReadFrom(ResponseText);

        if JsonResponse.Get('rate', JToken) then
            exit(JToken.AsValue().AsDecimal());

        exit(0);
    end;
}