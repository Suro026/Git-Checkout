# Debug: Medicine Orders Not Showing in Pharmacy Dashboard

## Quick Checks:

### 1. Check if Orders Are Being Created
Go to: http://localhost:5173/test-data
- Look for medicine orders in the database
- Check if they have the correct pharmacy_id

### 2. Check Browser Console
When you login as pharmacy and go to dashboard:
1. Press F12 to open console
2. Look for any errors related to fetching orders
3. Check if pharmacy_id is being found correctly

### 3. Manual Database Check
Run this SQL in Supabase SQL Editor:

```sql
-- Check if medicine orders exist
SELECT 
  mo.id,
  mo.medicines,
  mo.status,
  mo.created_at,
  p.full_name as patient_name,
  ph.pharmacy_name
FROM medicine_orders mo
JOIN profiles p ON p.id = mo.patient_id
JOIN pharmacies ph ON ph.id = mo.pharmacy_id
ORDER BY mo.created_at DESC;

-- Check if pharmacy has correct user_id
SELECT 
  id,
  pharmacy_name,
  user_id,
  email
FROM pharmacies
ORDER BY created_at DESC;
```

## Common Issues:

### Issue 1: Pharmacy Not Registered Properly
**Problem:** The pharmacy account doesn't have a corresponding entry in the pharmacies table
**Solution:** Register a new pharmacy account or check if existing one has user_id

### Issue 2: RLS Policy Blocking
**Problem:** Row Level Security is preventing pharmacy from seeing orders
**Solution:** Run this SQL to check policies:

```sql
-- Check RLS policies for medicine_orders
SELECT 
  schemaname,
  tablename,
  policyname,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'medicine_orders';
```

### Issue 3: Wrong Pharmacy Selected
**Problem:** Patient selected wrong pharmacy when ordering
**Solution:** Check which pharmacy was selected in the order

## Quick Fix SQL:

If orders exist but pharmacy can't see them, run this:

```sql
-- Temporarily disable RLS to test
ALTER TABLE medicine_orders DISABLE ROW LEVEL SECURITY;

-- Re-enable after testing
-- ALTER TABLE medicine_orders ENABLE ROW LEVEL SECURITY;
```

## Test Steps:

1. **Login as patient** → Place a medicine order
2. **Check test-data page** → Verify order was created
3. **Login as pharmacy** → Check if order appears in dashboard
4. **Check browser console** → Look for errors
5. **Run SQL queries** → Verify data and permissions

## Expected Flow:
1. Patient places order → `medicine_orders` table
2. Pharmacy logs in → Fetches orders for their pharmacy_id
3. Orders appear in pharmacy dashboard → Pending/Urgent sections