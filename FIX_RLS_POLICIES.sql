-- Fix RLS policies to allow patients to see ALL clinics and pharmacies

-- Drop old restrictive policies
DROP POLICY IF EXISTS "Patients can view verified clinics" ON public.clinics;
DROP POLICY IF EXISTS "Patients can view verified pharmacies" ON public.pharmacies;
DROP POLICY IF EXISTS "Patients can view doctors from verified clinics" ON public.doctors;

-- Create new open policies for clinics
CREATE POLICY "Anyone authenticated can view all clinics"
  ON public.clinics FOR SELECT
  TO authenticated
  USING (TRUE);

-- Create new open policies for pharmacies
CREATE POLICY "Anyone authenticated can view all pharmacies"
  ON public.pharmacies FOR SELECT
  TO authenticated
  USING (TRUE);

-- Create new open policies for doctors
CREATE POLICY "Anyone authenticated can view all doctors"
  ON public.doctors FOR SELECT
  TO authenticated
  USING (TRUE);

-- Keep the existing policies for clinic/pharmacy owners to manage their own data
-- (These should already exist, just making sure they work alongside the read policies)
