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
}