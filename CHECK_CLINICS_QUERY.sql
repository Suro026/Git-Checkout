-- Run this in Supabase SQL Editor to see what's in the database

-- Check all clinics
SELECT 
  id,
  clinic_name,
  email,
  user_id,
  verified,
  created_at
FROM public.clinics
ORDER BY created_at DESC;

-- Check if there are any RLS policies blocking reads
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'clinics';

-- Test the query that BookAppointment uses
SELECT id, clinic_name, address 
FROM public.clinics 
ORDER BY clinic_name;
