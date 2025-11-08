# Fix: No Clinics/Pharmacies Showing Up

## Problem
The patient dashboard shows "No clinics found" and "No pharmacies found" because your database is empty.

## Solution - Follow These Steps:

### Step 1: Check Current Data
1. Start your dev server if not running: `npm run dev`
2. Go to: http://localhost:5173/test-data
3. This page will show you what's currently in your database

### Step 2: Add Dummy Data to Database

#### Option A: Using Supabase Dashboard (Easiest)

1. **Open Supabase Dashboard**
   - Go to: https://nfijoztlzlfltbghydpy.supabase.co
   - Login to your account

2. **Open SQL Editor**
   - Click "SQL Editor" in the left sidebar
   - Click "New Query"

3. **Fix the Schema First** (Run this first if you get user_id errors)
   ```sql
   ALTER TABLE public.clinics ALTER COLUMN user_id DROP NOT NULL;
   ALTER TABLE public.pharmacies ALTER COLUMN user_id DROP NOT NULL;
   ```

4. **Add the Dummy Data** (Copy and paste this entire script)
   ```sql
   -- Insert dummy clinics
   INSERT INTO public.clinics (clinic_name, email, phone, address, verified, latitude, longitude) VALUES
     ('City Health Clinic', 'contact@cityhealthclinic.com', '+1-555-0101', '123 Main Street, Downtown', TRUE, 40.7128, -74.0060),
     ('Sunrise Medical Center', 'info@sunrisemedical.com', '+1-555-0102', '456 Oak Avenue, Westside', TRUE, 40.7580, -73.9855),
     ('Green Valley Clinic', 'hello@greenvalleyclinic.com', '+1-555-0103', '789 Pine Road, Northside', TRUE, 40.7489, -73.9680),
     ('Metro Care Hospital', 'contact@metrocare.com', '+1-555-0104', '321 Elm Street, Eastside', TRUE, 40.7614, -73.9776);

   -- Add doctors to clinics
   DO $$
   DECLARE
     clinic1_id UUID;
     clinic2_id UUID;
     clinic3_id UUID;
     clinic4_id UUID;
     gp_specialty_id UUID;
     cardio_specialty_id UUID;
     dentist_specialty_id UUID;
     pediatric_specialty_id UUID;
     ortho_specialty_id UUID;
   BEGIN
     SELECT id INTO clinic1_id FROM public.clinics WHERE clinic_name = 'City Health Clinic' LIMIT 1;
     SELECT id INTO clinic2_id FROM public.clinics WHERE clinic_name = 'Sunrise Medical Center' LIMIT 1;
     SELECT id INTO clinic3_id FROM public.clinics WHERE clinic_name = 'Green Valley Clinic' LIMIT 1;
     SELECT id INTO clinic4_id FROM public.clinics WHERE clinic_name = 'Metro Care Hospital' LIMIT 1;
     
     SELECT id INTO gp_specialty_id FROM public.specialties WHERE name = 'General Physician' LIMIT 1;
     SELECT id INTO cardio_specialty_id FROM public.specialties WHERE name = 'Cardiologist' LIMIT 1;
     SELECT id INTO dentist_specialty_id FROM public.specialties WHERE name = 'Dentist' LIMIT 1;
     SELECT id INTO pediatric_specialty_id FROM public.specialties WHERE name = 'Pediatrician' LIMIT 1;
     SELECT id INTO ortho_specialty_id FROM public.specialties WHERE name = 'Orthopedic' LIMIT 1;
     
     IF clinic1_id IS NOT NULL THEN
       INSERT INTO public.doctors (clinic_id, name, specialty_id, qualification, experience_years, available) VALUES
         (clinic1_id, 'Dr. Sarah Johnson', gp_specialty_id, 'MD, MBBS', 10, TRUE),
         (clinic1_id, 'Dr. Michael Chen', cardio_specialty_id, 'MD, Cardiology', 15, TRUE);
     END IF;
     
     IF clinic2_id IS NOT NULL THEN
       INSERT INTO public.doctors (clinic_id, name, specialty_id, qualification, experience_years, available) VALUES
         (clinic2_id, 'Dr. Emily Rodriguez', pediatric_specialty_id, 'MD, Pediatrics', 8, TRUE),
         (clinic2_id, 'Dr. James Wilson', ortho_specialty_id, 'MD, Orthopedics', 12, TRUE);
     END IF;
     
     IF clinic3_id IS NOT NULL THEN
       INSERT INTO public.doctors (clinic_id, name, specialty_id, qualification, experience_years, available) VALUES
         (clinic3_id, 'Dr. Lisa Anderson', dentist_specialty_id, 'DDS', 7, TRUE),
         (clinic3_id, 'Dr. Robert Taylor', gp_specialty_id, 'MD, MBBS', 20, TRUE);
     END IF;
     
     IF clinic4_id IS NOT NULL THEN
       INSERT INTO public.doctors (clinic_id, name, specialty_id, qualification, experience_years, available) VALUES
         (clinic4_id, 'Dr. Amanda White', cardio_specialty_id, 'MD, Cardiology', 18, TRUE),
         (clinic4_id, 'Dr. David Brown', gp_specialty_id, 'MD, MBBS', 14, TRUE);
     END IF;
   END $$;

   -- Insert dummy pharmacies
   INSERT INTO public.pharmacies (pharmacy_name, email, phone, address, verified, latitude, longitude) VALUES
     ('HealthPlus Pharmacy', 'contact@healthpluspharmacy.com', '+1-555-0201', '100 Market Street, Downtown', TRUE, 40.7128, -74.0050),
     ('MediCare Drugstore', 'info@medicaredrug.com', '+1-555-0202', '250 Broadway, Midtown', TRUE, 40.7580, -73.9845),
     ('Wellness Pharmacy', 'hello@wellnesspharmacy.com', '+1-555-0203', '500 Park Avenue, Uptown', TRUE, 40.7489, -73.9670),
     ('QuickMed Pharmacy', 'support@quickmedpharmacy.com', '+1-555-0204', '75 River Road, Riverside', TRUE, 40.7614, -73.9766);
   ```

5. **Click "Run"** to execute the script

### Step 3: Verify It Worked

1. Go back to: http://localhost:5173/test-data
2. Click "Refresh Data"
3. You should now see:
   - ✅ 4 Clinics
   - ✅ 4 Pharmacies

### Step 4: Check Patient Dashboard

1. Login as a patient
2. Go to: http://localhost:5173/dashboard/patient
3. You should now see:
   - ✅ Clinics in "Book Appointment" dropdown
   - ✅ Clinics in "Available Clinics" section
   - ✅ Pharmacies in "Nearby Pharmacies" section

## Still Not Working?

### Debug Checklist:
- [ ] Is your dev server running? (`npm run dev`)
- [ ] Did you run the SQL in Supabase Dashboard?
- [ ] Check browser console for errors (F12)
- [ ] Check the test page: http://localhost:5173/test-data
- [ ] Verify Supabase connection in `.env` file

### Common Errors:

**Error: "user_id violates not-null constraint"**
- Solution: Run the ALTER TABLE commands first (Step 2, part 3)

**Error: "No clinics available"**
- Solution: Make sure `verified = TRUE` in your SQL insert
- Check if data exists: Go to Supabase Dashboard → Table Editor → clinics

**Error: "Failed to load clinics"**
- Solution: Check browser console for the actual error
- Verify RLS policies allow reading clinics table
