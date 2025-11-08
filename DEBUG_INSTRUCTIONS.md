# Debug Patient Dashboard Not Rendering

## Quick Checks:

### 1. Check Browser Console
Press `F12` and look for errors. Common issues:
- Authentication errors
- Database query errors
- Component rendering errors

### 2. Check if you're logged in as a patient
- Go to http://localhost:5173/login
- Make sure you're logged in with a patient account
- If you registered as "clinic" or "pharmacy", you won't see the patient dashboard

### 3. Test the data directly
Go to: http://localhost:5173/test-data
This will show you if clinics and pharmacies are in the database

### 4. Check the URL
Make sure you're at: http://localhost:5173/dashboard/patient

### 5. Run this in browser console (F12):
```javascript
// Check if user is logged in
const checkAuth = async () => {
  const { data: { user } } = await window.supabase.auth.getUser();
  console.log('User:', user);
  
  if (!user) {
    console.log('❌ Not logged in');
    return;
  }
  
  // Check user role
  const { data: roles } = await window.supabase
    .from('user_roles')
    .select('*')
    .eq('user_id', user.id);
  console.log('User roles:', roles);
};

checkAuth();
```

## Common Issues:

### Issue 1: "Not logged in" or redirecting to login
**Solution:** Login with a patient account first

### Issue 2: Blank page with no errors
**Solution:** Check if dev server is running: `npm run dev`

### Issue 3: "No clinics found" / "No pharmacies found"
**Solution:** Run the SQL script from `ADD_DUMMY_DATA_FIXED.sql` in Supabase

### Issue 4: RLS Policy Error
**Solution:** The RLS policies might be blocking reads. Run this in Supabase SQL Editor:
```sql
-- Allow authenticated users to read all clinics
DROP POLICY IF EXISTS "Patients can view verified clinics" ON public.clinics;
CREATE POLICY "Anyone can view clinics"
  ON public.clinics FOR SELECT
  TO authenticated
  USING (TRUE);

-- Allow authenticated users to read all pharmacies
DROP POLICY IF EXISTS "Patients can view verified pharmacies" ON public.pharmacies;
CREATE POLICY "Anyone can view pharmacies"
  ON public.pharmacies FOR SELECT
  TO authenticated
  USING (TRUE);
```

## Still not working?

Share the error message from browser console (F12 → Console tab)
