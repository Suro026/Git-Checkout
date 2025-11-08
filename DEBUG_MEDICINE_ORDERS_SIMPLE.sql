-- Debug medicine orders issue

-- Step 1: Check if table exists and has data
SELECT COUNT(*) as total_orders FROM public.medicine_orders;

-- Step 2: Check table structure
\d public.medicine_orders;

-- Step 3: Check if there are any orders
SELECT 
  id,
  medicines,
  pharmacy_id,
  patient_id,
  status,
  created_at
FROM public.medicine_orders
ORDER BY created_at DESC
LIMIT 5;

-- Step 4: Check RLS policies
SELECT 
  schemaname,
  tablename,
  policyname,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'medicine_orders';

-- Step 5: Test the exact query that's failing
SELECT 
  id,
  medicines,
  delivery_address,
  phone,
  payment_method,
  is_urgent,
  status,
  notes,
  created_at
FROM public.medicine_orders
WHERE pharmacy_id = '5690fcf0-6a1e-43e5-9bbc-dea034da60cb'
ORDER BY created_at DESC;

-- Step 6: Check if the profiles join is the issue
SELECT 
  mo.id,
  mo.medicines,
  mo.status,
  p.full_name
FROM public.medicine_orders mo
LEFT JOIN public.profiles p ON p.id = mo.patient_id
WHERE mo.pharmacy_id = '5690fcf0-6a1e-43e5-9bbc-dea034da60cb';