# Setup Email Verification for Clinic & Pharmacy

## Step 1: Configure Redirect URLs in Supabase

1. **Go to Supabase Dashboard**: https://nfijoztlzlfltbghydpy.supabase.co
2. **Click "Authentication"** in the left sidebar
3. **Click "URL Configuration"**
4. **Add these URLs to "Redirect URLs":**
   ```
   http://localhost:5173/dashboard/patient
   http://localhost:5173/dashboard/pharmacy
   http://localhost:5173/dashboard/clinic
   http://localhost:5173/
   ```
5. **Click "Save"**

## Step 2: Verify Email Settings

1. **Still in Authentication → Settings**
2. **Check "Email Confirmation" is enabled**
3. **Check "SMTP Settings"** - should be using Supabase's built-in email service

## Step 3: Test the Flow

### For Clinic Registration:
1. Go to `/register`
2. Click "Clinic" tab
3. Fill in clinic details
4. Click "Create Clinic Account"
5. Check email for verification link
6. Click the link → should redirect to `/dashboard/clinic`

### For Pharmacy Registration:
1. Go to `/register`
2. Click "Pharmacy" tab
3. Fill in pharmacy details
4. Click "Create Pharmacy Account"
5. Check email for verification link
6. Click the link → should redirect to `/dashboard/pharmacy`

## What Changed:

**File:** `src/lib/auth.ts`
- Updated `signUp` function to use role-specific redirect URLs
- Patient → `/dashboard/patient`
- Pharmacy → `/dashboard/pharmacy`
- Clinic → `/dashboard/clinic`

## How It Works Now:

1. **User registers** → Account created but unconfirmed
2. **Email sent** with verification link pointing to role-specific dashboard
3. **User clicks email link** → Account confirmed + redirected to their dashboard
4. **User can login** and access their dashboard

## Troubleshooting:

### If email verification still doesn't work:
1. Check spam/junk folder
2. Verify redirect URLs are saved in Supabase
3. Check browser console for errors
4. Try with a different email address

### If redirect doesn't work after email verification:
1. Make sure all redirect URLs are added to Supabase
2. Check that the URLs match exactly (including http/https)
3. Clear browser cache and try again

## Production Setup:

For production, replace `http://localhost:5173` with your actual domain:
```
https://yourdomain.com/dashboard/patient
https://yourdomain.com/dashboard/pharmacy
https://yourdomain.com/dashboard/clinic
https://yourdomain.com/
```