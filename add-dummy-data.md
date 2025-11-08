# Adding Dummy Clinics and Pharmacies

## Option 1: Using Supabase CLI (Recommended)

If you have Supabase CLI installed, run:

```bash
cd Frontend/Kllinic
supabase db push
```

This will apply the migration file `20251108_add_dummy_data.sql` to your database.

## Option 2: Manual SQL Execution

1. Go to your Supabase Dashboard
2. Navigate to the SQL Editor
3. Copy and paste the contents of `supabase/migrations/20251108_add_dummy_data.sql`
4. Click "Run" to execute the SQL

## What Gets Added

### 4 Dummy Clinics:
1. **City Health Clinic** - 123 Main Street, Downtown
   - Dr. Sarah Johnson (General Physician)
   - Dr. Michael Chen (Cardiologist)

2. **Sunrise Medical Center** - 456 Oak Avenue, Westside
   - Dr. Emily Rodriguez (Pediatrician)
   - Dr. James Wilson (Orthopedic)

3. **Green Valley Clinic** - 789 Pine Road, Northside
   - Dr. Lisa Anderson (Dentist)
   - Dr. Robert Taylor (General Physician)

4. **Metro Care Hospital** - 321 Elm Street, Eastside
   - Dr. Amanda White (Cardiologist)
   - Dr. David Brown (General Physician)

### 4 Dummy Pharmacies:
1. **HealthPlus Pharmacy** - 100 Market Street, Downtown
2. **MediCare Drugstore** - 250 Broadway, Midtown
3. **Wellness Pharmacy** - 500 Park Avenue, Uptown
4. **QuickMed Pharmacy** - 75 River Road, Riverside

## Verification

After running the migration, you should see:
- Clinics appearing in the "Book Appointment" dropdown
- Clinics listed in the "Available Clinics" section
- Pharmacies displayed in the "Nearby Pharmacies" section

All data is marked as `verified = TRUE` so it will be visible to patients immediately.
