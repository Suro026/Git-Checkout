-- Check all clinics (verified and unverified)
SELECT clinic_name, email, verified, created_at 
FROM public.clinics 
ORDER BY created_at DESC;

-- Check all pharmacies (verified and unverified)
SELECT pharmacy_name, email, verified, created_at 
FROM public.pharmacies 
ORDER BY created_at DESC;

-- To verify a specific clinic (replace the email with the actual clinic email)
UPDATE public.clinics 
SET verified = TRUE 
WHERE email = 'your-clinic-email@example.com';

-- To verify a specific pharmacy (replace the email with the actual pharmacy email)
UPDATE public.pharmacies 
SET verified = TRUE 
WHERE email = 'your-pharmacy-email@example.com';

-- To verify ALL real registered clinics (not dummy data)
UPDATE public.clinics 
SET verified = TRUE 
WHERE email NOT LIKE '%@parkstreetmedical.com%' 
  AND email NOT LIKE '%@saltlakehospital.com%'
  AND email NOT LIKE '%@gariahatclinic.com%'
  AND email NOT LIKE '%@howrahhospital.com%';

-- To verify ALL real registered pharmacies (not dummy data)
UPDATE public.pharmacies 
SET verified = TRUE 
WHERE email NOT LIKE '%@apolloparkst.com%' 
  AND email NOT LIKE '%@medplusgariahat.com%'
  AND email NOT LIKE '%@healthbuddysaltlake.com%'
  AND email NOT LIKE '%@wellnesshowrah.com%';
