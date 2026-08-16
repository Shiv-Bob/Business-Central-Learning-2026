xmlport 50001 "Customer Export CSV"
{
    // ─────────────────────────────────────────────────────────────
    // Direction = Export means this XMLPort WRITES data OUT.
    // Format = VariableText = CSV/flat file format.
    // ─────────────────────────────────────────────────────────────
    Direction = Export;
    Format = VariableText;
    Caption = 'Customer Export CSV';

    // FieldDelimiter: character wrapping each field value.
    // '"' means fields are quoted: "C00001","John Smith","London"
    FieldDelimiter = '"';

    // FieldSeparator: character between fields.
    // Default is comma for CSV.
    FieldSeparator = ',';

    // TextEncoding: important for international characters.
    // UTF8 handles special chars (German umlauts, accented French etc.)
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            // ─────────────────────────────────────────────────────
            // tableelement = one row per record in this table.
            // The variable name (CustomerRec) follows your naming
            // convention — Rec suffix for Record variables.
            // ─────────────────────────────────────────────────────
            tableelement(CustomerRec; Customer)
            {
                // ─────────────────────────────────────────────────
                // XmlName is the column header in the CSV output.
                // fieldelement = one column per field.
                // ─────────────────────────────────────────────────
                fieldelement(No; CustomerRec."No.")
                {
                    XmlName = 'CustomerNo';
                }
                fieldelement(Name; CustomerRec.Name)
                {
                    XmlName = 'CustomerName';
                }
                fieldelement(Address; CustomerRec.Address)
                {
                    XmlName = 'Address';
                }
                fieldelement(City; CustomerRec.City)
                {
                    XmlName = 'City';
                }
                fieldelement(CountryCode; CustomerRec."Country/Region Code")
                {
                    XmlName = 'CountryCode';
                }
                fieldelement(PhoneNo; CustomerRec."Phone No.")
                {
                    XmlName = 'PhoneNo';
                }
                fieldelement(Email; CustomerRec."E-Mail")
                {
                    XmlName = 'Email';
                }
                fieldelement(CreditLimit; CustomerRec."Credit Limit (LCY)")
                {
                    XmlName = 'CreditLimit';
                }

            }
        }
    }
}