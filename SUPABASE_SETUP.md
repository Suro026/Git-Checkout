# Supabase Setup Guide

## ✅ After Running Migrations in SQL Editor

### Step 1: Verify Migrations Ran Successfully

1. Go to your Supabase Dashboard → **Table Editor**
2. Verify these tables exist:
   - ✅ `profiles`
   - ✅ `user_roles`
   - ✅ `specialties`
   - ✅ `clinics`
   - ✅ `doctors`
   - ✅ `pharmacies`
   - ✅ `appointments`
   - ✅ `health_records`

3. Go to **Database** → **Functions** and verify:
   - ✅ `has_role` function exists
   - ✅ `handle_new_user` function exists
   - ✅ `handle_user_role_on_signup` function exists
   - ✅ `handle_pharmacy_on_signup` function exists
   - ✅ `handle_clinic_on_signup` function exists

4. Go to **Database** → **Triggers** and verify triggers are created

### Step 2: Get Your Supabase Credentials

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project (Project ID: `xmhwyvojwukgowbhqhpo`)
3. Go to **Settings** → **API**
4. Copy the following values:
   - **Project URL** (under "Project URL")
   - **anon/public key** (under "Project API keys" → "anon" → "public")

### Step 3: Create Environment Variables File

1. In the `Frontend/Kllinic` folder, create a file named `.env`
2. Add your Supabase credentials:

```env
VITE_SUPABASE_URL=https://xmhwyvojwukgowbhqhpo.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=your-anon-key-here
```

**⚠️ Important:** Replace `your-anon-key-here` with your actual anon/public key from Step 2.

### Step 4: Verify Database Types (Optional but Recommended)

If you want to regenerate TypeScript types from your Supabase database:

1. Install Supabase CLI (if not already installed):
   ```bash
   npm install -g supabase
   ```

2. Login to Supabase:
   ```bash
   supabase login
   ```

3. Link your project:
   ```bash
   supabase link --project-ref xmhwyvojwukgowbhqhpo
   ```

4. Generate types:
   ```bash
   supabase gen types typescript --linked > src/integrations/supabase/types.ts
   ```

### Step 5: Test the Connection

1. Start your development server:
   ```bash
   npm run dev
   ```

2. Open your browser and navigate to the app
3. Try to register a new user to test the connection
4. Check the browser console for any errors

### Step 6: Configure Authentication (If Needed)

1. Go to **Authentication** → **Providers** in Supabase Dashboard
2. Enable email authentication (usually enabled by default)
3. Configure email templates if needed:
   - Go to **Authentication** → **Email Templates**
   - Customize confirmation and password reset emails

### Step 7: Set Up Row Level Security (RLS) Policies

The migrations should have already set up RLS policies, but verify:

1. Go to **Database** → **Policies**
2. Ensure all tables have the necessary policies:
   - Users can only access their own data
   - Patients can view verified clinics/pharmacies
   - Clinics can manage their own data

### Step 8: Test User Registration

1. Start your app: `npm run dev`
2. Navigate to `/register`
3. Try registering:
   - A patient account
   - A pharmacy account
   - A clinic account
4. Verify that:
   - User is created in `auth.users`
   - Profile is created in `profiles` table
   - Role is assigned in `user_roles` table
   - Pharmacy/Clinic data is created (if applicable)

### Troubleshooting

**Issue: "Cannot find module" errors**
- Make sure you've created the `.env` file in `Frontend/Kllinic/`
- Restart your development server after creating `.env`

**Issue: "Invalid API key"**
- Double-check your `VITE_SUPABASE_PUBLISHABLE_KEY` in `.env`
- Make sure you're using the **anon/public** key, not the service_role key

**Issue: Tables not found**
- Verify all migrations ran successfully
- Check the SQL Editor history to see if there were any errors

**Issue: RLS policies blocking queries**
- Verify policies are created correctly
- Check that the authenticated user has the correct role assigned

### Next Steps

- ✅ Database is set up
- ✅ Environment variables configured
- ✅ Types are generated (optional)
- 🚀 Start building your application!

