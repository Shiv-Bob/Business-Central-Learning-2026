codeunit 50007 "Discount Rules Cache"
{
    // ─────────────────────────────────────────────────────────────
    // SingleInstance = true
    //
    // BC creates ONE instance of this codeunit per user session
    // and keeps it alive. Global variables retain their values
    // across ALL calls within the same session.
    //
    // Real-world problem this solves:
    // Imagine calculating discounts for a Sales Order with
    // 50 lines. Without caching, each line triggers a database
    // read for the discount percentage = 50 DB reads.
    // With SingleInstance cache = 1 DB read total.
    // ─────────────────────────────────────────────────────────────
    SingleInstance = true;

    var
        // Dictionary acts as our in-memory cache.
        // Key   = Customer Price Group code
        // Value = Discount percentage as text (Dictionary only holds Text)
        DiscountCache: Dictionary of [Code[20], Text];
        IsFullyLoaded: Boolean;
        LoadCount: Integer; // tracks how many times we actually hit the DB

    // ─────────────────────────────────────────────────────────────
    // PUBLIC: Get discount % for a specific Customer Price Group.
    // Loads from DB on first request for that group,
    // then serves from memory for all future requests.
    // ─────────────────────────────────────────────────────────────
    procedure GetDiscountPercent(CustomerPriceGroup: Code[20]): Decimal
    var
        DiscountText: Text;
    begin
        // Already in cache? Return immediately — no DB hit.
        if DiscountCache.Get(CustomerPriceGroup, DiscountText) then
            exit(EvaluateDecimal(DiscountText));

        // Not cached yet — load this specific group from DB.
        exit(LoadAndCacheGroup(CustomerPriceGroup));
    end;

    // ─────────────────────────────────────────────────────────────
    // PUBLIC: Preload ALL discount groups at once.
    // Use this at the start of batch processing (e.g., posting
    // a large order) to load everything in one DB query instead
    // of one query per line.
    // ─────────────────────────────────────────────────────────────
    procedure PreloadAllGroups()
    var
        CustomerDiscountGroupRec: Record "Customer Discount Group";
    begin
        if IsFullyLoaded then
            exit;

        CustomerDiscountGroupRec.SetLoadFields(Code);
        if CustomerDiscountGroupRec.FindSet() then
            repeat
                if not DiscountCache.ContainsKey(CustomerDiscountGroupRec.Code) then
                    LoadAndCacheGroup(CustomerDiscountGroupRec.Code);
            until CustomerDiscountGroupRec.Next() = 0;

        IsFullyLoaded := true;
    end;

    // ─────────────────────────────────────────────────────────────
    // PUBLIC: How many times did we actually read the database?
    // Call this in demos/testing to prove the cache is working.
    // ─────────────────────────────────────────────────────────────
    procedure GetDatabaseReadCount(): Integer
    begin
        exit(LoadCount);
    end;

    // ─────────────────────────────────────────────────────────────
    // PUBLIC: Invalidate the entire cache.
    // Call this after any discount rule changes so the next
    // request re-reads fresh values from the database.
    // ─────────────────────────────────────────────────────────────
    procedure InvalidateCache()
    begin
        Clear(DiscountCache);
        IsFullyLoaded := false;
        LoadCount := 0;
    end;

    // ─────────────────────────────────────────────────────────────
    // PUBLIC: Invalidate a single group's cached value.
    // More targeted than InvalidateCache — use when only one
    // group's discount was changed, not all of them.
    // ─────────────────────────────────────────────────────────────
    procedure InvalidateCacheForGroup(CustomerPriceGroup: Code[20])
    begin
        if DiscountCache.ContainsKey(CustomerPriceGroup) then
            DiscountCache.Remove(CustomerPriceGroup);

        // Full load is no longer valid since we removed one entry
        IsFullyLoaded := false;
    end;

    // ─────────────────────────────────────────────────────────────
    // PRIVATE: Actually reads from the database and stores result.
    // This is the ONLY place in this codeunit that hits the DB.
    // ─────────────────────────────────────────────────────────────
    local procedure LoadAndCacheGroup(CustomerPriceGroup: Code[20]): Decimal
    var
        SalesLineDiscountRec: Record "Sales Line Discount";
        DiscountPercent: Decimal;
    begin
        LoadCount += 1;

        // "Sales Type" Option index 1 = "Customer Disc. Group"
        // Confirmed from Sales Line Discount table definition:
        // OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign
        SalesLineDiscountRec.SetRange("Sales Type", 1);
        SalesLineDiscountRec.SetRange("Sales Code", CustomerPriceGroup);
        SalesLineDiscountRec.SetLoadFields("Line Discount %");

        if SalesLineDiscountRec.FindFirst() then
            DiscountPercent := SalesLineDiscountRec."Line Discount %"
        else
            DiscountPercent := 0;

        DiscountCache.Set(CustomerPriceGroup, Format(DiscountPercent));

        exit(DiscountPercent);
    end;

    // ─────────────────────────────────────────────────────────────
    // PRIVATE: Safely converts stored Text back to Decimal.
    // ─────────────────────────────────────────────────────────────
    local procedure EvaluateDecimal(Value: Text): Decimal
    var
        Result: Decimal;
    begin
        if Evaluate(Result, Value) then
            exit(Result);
        exit(0);
    end;
}