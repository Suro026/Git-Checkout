-- COMPLETE FIX: Make all clinics and pharmacies visible to patients

-- Step 1: Check current policies
SELECT tablename, policyname, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('clinics', 'pharmacies', 'doctors');

-- Step 2: Drop ALL existing SELECT policies for clinics
DROP POLICY IF EXISTS "Patients can view verified clinics" ON public.clinics;
DROP POLICY IF EXISTS "Anyone can view clinics" ON public.clinics;
DROP POLICY IF EXISTS "Anyone authenticated can view all clinics" ON public.clinics;

-- Step 3: Drop ALL existing SELECT policies for pharmacies
DROP POLICY IF EXISTS "Patients can view verified pharmacies" ON public.pharmacies;
DROP POLICY IF EXISTS "Anyone can view pharmacies" ON public.pharmacies;
DROP POLICY IF EXISTS "Anyone authenticated can view all pharmacies" ON public.pharmacies;

-- Step 4: Drop ALL existing SELECT policies for doctors
DROP POLICY IF EXISTS "Patients can view doctors from verified clinics" ON public.doctors;
DROP POLICY IF EXISTS "Anyone can view doctors" ON public.doctors;
DROP POLICY IF EXISTS "Anyone authenticated can view all doctors" ON public.doctors;

-- Step 5: Create new simple policies
CREATE POLICY "allow_all_read_clinics"
  ON public.clinics
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_all_read_pharmacies"
  ON public.pharmacies
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_all_read_doctors"
  ON public.doctors
  FOR SELECT
  TO authenticated
  USING (true);

-- Step 6: Verify the policies were created
SELECT tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename IN ('clinics', 'pharmacies', 'doctors')
AND cmd = 'SELECT';
