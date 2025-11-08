-- Fix the foreign key relationship for medicine_orders

-- Step 1: Check current table structure
\d public.medicine_orders;

-- Step 2: Add foreign key constraint if it doesn't exist
-- (This might fail if it already exists, that's okay)
ALTER TABLE public.medicine_orders 
ADD CONSTRAINT medicine_orders_patient_id_fkey 
FOREIGN KEY (patient_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Step 3: Verify the constraint was added
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name='medicine_orders';