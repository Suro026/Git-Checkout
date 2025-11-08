# Fix Email Verification for Clinic & Pharmacy Registration

## Option 1: Disable Email Confirmation (Quick Fix)

### Step 1: Go to Supabase Dashboard
1. Open your Supabase project: https://nfijoztlzlfltbghydpy.supabase.co
2. Go to **Authentication** → **Settings**
3. Scroll down to **"Email Confirmation"**
4. **Turn OFF** "Enable email confirmations"
5. Click **Save**

### Step 2: Test Registration
- Try registering a new clinic/pharmacy account
- Should work immediately without email verification

## Option 2: Enable Email Verification (Proper Setup)

### Step 1: Configure Email Settings
1. Go to **Authentication** → **Settings**
2. Scroll to **SMTP Settings**
3. Either:
   - Use Supabase's built-in email service (limited)
   - Or configure your own SMTP (Gmail, SendGrid, etc.)

### Step 2: Set Redirect URLs
1. In **Authentication** → **URL Configuration**
2. Add your site URL: `http://localhost:5173`
3. Add redirect URLs:
   - `http://localhost:5173/dashboard/clinic`
   - `http://localhost:5173/dashboard/pharmacy`

## Option 3: Auto-Confirm Users (Development)

Run this SQL in Supabase SQL Editor:

```sql
-- Auto-confirm all existing unconfirmed users
UPDATE auth.users 
SET email_confirmed_at = NOW(), 
    confirmed_at = NOW() 
WHERE email_confirmed_at IS NULL;

-- Create a function to auto-confirm new users (for development only)
CREATE OR REPLACE FUNCTION public.auto_confirm_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Auto-confirm user in development
  UPDATE auth.users 
  SET email_confirmed_at = NOW(), 
      confirmed_at = NOW() 
  WHERE id = NEW.id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to auto-confirm new users
DROP TRIGGER IF EXISTS auto_confirm_new_user ON auth.users;
CREATE TRIGGER auto_confirm_new_user
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.auto_confirm_user();
```

## Recommended for Development: Option 1

For testing and development, **Option 1** (disable email confirmation) is the easiest. You can enable it later for production.

## Check Current Settings

Run this to see current auth settings:
```sql
-- Check if users need email confirmation
SELECT 
  email,
  email_confirmed_at,
  confirmed_at,
  created_at
FROM auth.users
ORDER BY created_at DESC;
```

If `email_confirmed_at` is NULL, the user needs to confirm their email.