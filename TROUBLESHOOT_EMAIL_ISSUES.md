# Troubleshoot Email Not Arriving

## Quick Checks:

### 1. Check Spam/Junk Folder
- Look in your spam/junk/promotions folder
- Supabase emails often end up there

### 2. Check Email Settings in Supabase
1. Go to **Supabase Dashboard** → **Authentication** → **Settings**
2. Scroll to **"Email Confirmation"**
3. Make sure it's **enabled** (toggle should be ON)
4. Check **"SMTP Settings"** section

### 3. Check Rate Limits
Supabase free tier has email limits:
- **3 emails per hour** for free accounts
- If you've been testing, you might have hit the limit

## Common Issues & Solutions:

### Issue 1: Using Free Supabase Email Service
**Problem:** Supabase's built-in email service is limited and unreliable
**Solution:** Wait 1 hour and try again, or set up custom SMTP

### Issue 2: Email Provider Blocking
**Problem:** Gmail/Outlook might block Supabase emails
**Solution:** Try with a different email provider (Yahoo, ProtonMail, etc.)

### Issue 3: Wrong Email Configuration
**Check this in Supabase:**
1. **Authentication** → **Settings**
2. **Email Templates** → **Confirm signup**
3. Make sure the template exists and is enabled

## Quick Test:

### Option 1: Try Different Email
Register with a different email address (Gmail, Yahoo, etc.)

### Option 2: Check Supabase Logs
1. Go to **Supabase Dashboard** → **Logs**
2. Look for email-related errors

### Option 3: Disable Email Confirmation Temporarily
1. **Authentication** → **Settings**
2. **Turn OFF** "Enable email confirmations"
3. Test registration (should work immediately)
4. **Turn ON** again later

## Set Up Custom SMTP (Recommended):

### Using Gmail SMTP:
1. **Authentication** → **Settings** → **SMTP Settings**
2. **Enable custom SMTP**
3. **Settings:**
   ```
   Host: smtp.gmail.com
   Port: 587
   Username: your-gmail@gmail.com
   Password: your-app-password (not regular password)
   ```

### Using SendGrid (Free tier):
1. Sign up at sendgrid.com
2. Get API key
3. Configure in Supabase SMTP settings

## Immediate Solution:

**For testing purposes, temporarily disable email confirmation:**

1. **Supabase Dashboard** → **Authentication** → **Settings**
2. **Turn OFF** "Enable email confirmations"
3. Now registration will work immediately without email verification
4. **Turn ON** again when you fix the email issue

## Check Registration Status:

Run this SQL in Supabase to see if accounts are being created:

```sql
-- Check recent registrations
SELECT 
  email,
  email_confirmed_at,
  confirmed_at,
  created_at,
  raw_user_meta_data->>'role' as role
FROM auth.users
ORDER BY created_at DESC
LIMIT 10;
```

If you see the account but `email_confirmed_at` is NULL, the account was created but email wasn't sent/received.