# Quick Setup - Add Dummy Data to Your Database

## Step 1: Go to Supabase Dashboard

1. Open your browser and go to: https://nfijoztlzlfltbghydpy.supabase.co
2. Login to your Supabase account
3. Click on "SQL Editor" in the left sidebar

## Step 2: Run the SQL Script

Copy and paste this ENTIRE script into the SQL Editor and click "Run":

```sql
-- Add dummy clinics and pharmacies for testing

-- Insert dummy clinics (without user_id since we're adding test data)
INSERT INTO public.clinics (clinic_name, email, phone, address, verified, latitude, longitude) VALUES
  ('City Health Clinic', 'contact@cityhealthclinic.com', '+1-555-0101', '123 Main Street, Downtown', TRUE, 40.7128, -74.0060),
  ('Sunrise Medical Center', 'info@sunrisemedical.com', '+1-555-0102', '456 Oak Avenue, Westside', TRUE, 40.7580, -73.9855),
  ('Green Valley Clinic', 'hello@greenvalleyclinic.com', '+1-555-0103', '789 Pine Road, Northside', TRUE, 40.7489, -73.9680),
  ('Metro Care Hospital', 'contact@metrocare.com', '+1-555-0104', '321 Elm Street, Eastside', TRUE, 40.7614, -73.9776)
ON CONFLICT (user_id) DO NOTHING;

-- Get the clinic IDs and add doctors
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
  -- Get clinic IDs
  SELECT id INTO clinic1_id FROM public.clinics WHERE clinic_name = 'City Health Clinic' LIMIT 1;
  SELECT id INTO clinic2_id FROM public.clinics WHERE clinic_name = 'Sunrise Medical Center' LIMIT 1;
  SELECT id INTO clinic3_id FROM public.clinics WHERE clinic_name = 'Green Valley Clinic' LIMIT 1;
  SELECT id INTO clinic4_id FROM public.clinics WHERE clinic_name = 'Metro Care Hospital' LIMIT 1;
  
  -- Get specialty IDs
  SELECT id INTO gp_specialty_id FROM public.specialties WHERE name = 'General Physician' LIMIT 1;
  SELECT id INTO cardio_specialty_id FROM public.specialties WHERE name = 'Cardiologist' LIMIT 1;
  SELECT id INTO dentist_specialty_id FROM public.specialties WHERE name = 'Dentist' LIMIT 1;
  SELECT id INTO pediatric_specialty_id FROM public.specialties WHERE name = 'Pediatrician' LIMIT 1;
  SELECT id INTO ortho_specialty_id FROM public.specialties WHERE name = 'Orthopedic' LIMIT 1;
  
  -- Only insert if we have valid clinic IDs
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

-- Insert dummy pharmacies (without user_id since we're adding test data)
INSERT INTO public.pharmacies (pharmacy_name, email, phone, address, verified, latitude, longitude) VALUES
  ('HealthPlus Pharmacy', 'contact@healthpluspharmacy.com', '+1-555-0201', '100 Market Street, Downtown', TRUE, 40.7128, -74.0050),
  ('MediCare Drugstore', 'info@medicaredrug.com', '+1-555-0202', '250 Broadway, Midtown', TRUE, 40.7580, -73.9845),
  ('Wellness Pharmacy', 'hello@wellnesspharmacy.com', '+1-555-0203', '500 Park Avenue, Uptown', TRUE, 40.7489, -73.9670),
  ('QuickMed Pharmacy', 'support@quickmedpharmacy.com', '+1-555-0204', '75 River Road, Riverside', TRUE, 40.7614, -73.9766)
ON CONFLICT (user_id) DO NOTHING;
```

## Step 3: Verify the Data

After running the script, you can verify by running these queries:

```sql
-- Check clinics
SELECT clinic_name, address FROM public.clinics WHERE verified = true;

-- Check pharmacies
SELECT pharmacy_name, address FROM public.pharmacies WHERE verified = true;

-- Check doctors
SELECT d.name, s.name as specialty, c.clinic_name 
FROM public.doctors d
JOIN public.specialties s ON d.specialty_id = s.id
JOIN public.clinics c ON d.clinic_id = c.id;
```

## Step 4: Refresh Your App

After adding the data, refresh your patient dashboard and you should see:
- ✅ 4 clinics in the "Book Appointment" dropdown
- ✅ Clinics listed in "Available Clinics" section
- ✅ 4 pharmacies in "Nearby Pharmacies" section

## Troubleshooting

If you get an error about `user_id` being required:
1. The clinics/pharmacies tables have a NOT NULL constraint on user_id
2. We need to modify the table to make user_id nullable for test data
3. Run this first:

```sql
ALTER TABLE public.clinics ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE public.pharmacies ALTER COLUMN user_id DROP NOT NULL;
```

Then run the main script above.
