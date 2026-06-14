codeunit 50009 "SingleInstance Proof Demo"
{
    // ─────────────────────────────────────────────────────────────
    // Run these procedures from a page action to SEE and PROVE
    // that SingleInstance caching actually works.
    // ─────────────────────────────────────────────────────────────

    // DEMO 1: Proves DB is only read once per unique group
    procedure DemoLazyLoading()
    var
        DiscountRulesCache: Codeunit "Discount Rules Cache";
        Output: Text;
        i: Integer;
    begin
        Output := '=== Lazy Loading Demo ===\';
        Output += 'Calling GetDiscountPercent("RETAIL") 5 times...\';
        Output += '\';

        for i := 1 to 5 do begin
            DiscountRulesCache.GetDiscountPercent('RETAIL');
            Output += StrSubstNo(
                'Call %1 → DB reads so far: %2\',
                i,
                DiscountRulesCache.GetDatabaseReadCount());
        end;

        Output += '\';
        Output += 'Result: DB was read exactly ONCE.\';
        Output += 'Calls 2-5 were served from memory.';

        Message(Output);
    end;

    // DEMO 2: Proves invalidation forces a fresh DB read
    procedure DemoInvalidation()
    var
        DiscountRulesCache: Codeunit "Discount Rules Cache";
    begin
        // First call — reads DB, caches result
        DiscountRulesCache.GetDiscountPercent('RETAIL');
        Message('After first call → DB reads: %1 (loaded from DB)',
            DiscountRulesCache.GetDatabaseReadCount());

        // Second call — served from cache
        DiscountRulesCache.GetDiscountPercent('RETAIL');
        Message('After second call → DB reads: %1 (from cache, no new DB read)',
            DiscountRulesCache.GetDatabaseReadCount());

        // Invalidate — wipes the cached value
        DiscountRulesCache.InvalidateCacheForGroup('RETAIL');
        Message('Cache invalidated for RETAIL group.');

        // Third call — cache is empty again, forces DB read
        DiscountRulesCache.GetDiscountPercent('RETAIL');
        Message('After invalidation + call → DB reads: %1 (re-read from DB)',
            DiscountRulesCache.GetDatabaseReadCount());
    end;

    // DEMO 3: Proves the instance is SHARED across codeunits
    procedure DemoSharedInstance()
    var
        DiscountRulesCache1: Codeunit "Discount Rules Cache";
        DiscountRulesCache2: Codeunit "Discount Rules Cache";
    begin
        // Load via Cache1
        DiscountRulesCache1.GetDiscountPercent('RETAIL');
        Message('Loaded via Cache1 → DB reads via Cache2: %1\(Should be 1 — same instance!)',
            DiscountRulesCache2.GetDatabaseReadCount());
        // Both variables point to the SAME instance.
        // DB read via Cache1 is visible via Cache2.
    end;
}