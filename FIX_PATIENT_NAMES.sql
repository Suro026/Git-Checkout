-- Fix missing patient names in pharmacy dashboard

-- Step 1: Check if profiles exist for users who placed orders
SELECT 
  mo.id as order_id,
  mo.patient_id,
  u.email,
  u.raw_user_meta_data->>'full_name' as meta_name,
  p.full_name as profile_name
FROM medicine_orders mo
JOIN auth.users u ON u.id = mo.patient_id
LEFT JOIN profiles p ON p.id = mo.patient_id
ORDER BY mo.created_at DESC;

-- Step 2: Create missing profiles from user metadata
INSERT INTO public.profiles (id, full_name, phone)
SELECT 
  u.id,
  COALESCE(u.raw_user_meta_data->>'full_name', u.email),
  COALESCE(u.raw_user_meta_data->>'phone', '')
FROM auth.users u
LEFT JOIN public.profiles p ON p.id = u.id
WHERE p.id IS NULL;

-- Step 3: Update any empty full_name fields
UPDATE public.profiles 
SET full_name = COALESCE(
  (SELECT raw_user_meta_data->>'full_name' FROM auth.users WHERE id = profiles.id),
  (SELECT email FROM auth.users WHERE id = profiles.id)
)
WHERE full_name IS NULL OR full_name = '';

-- Step 4: Verify the fix
SELECT 
  mo.id as order_id,
  p.full_name as patient_name,
  mo.medicines
FROM medicine_orders mo
JOIN profiles p ON p.id = mo.patient_id
ORDER BY mo.created_at DESC;