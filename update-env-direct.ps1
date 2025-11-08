# Direct .env file updater - Run this script and follow the prompts

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Supabase .env File Updater" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get Project URL
Write-Host "Step 1: Enter your Supabase Project URL" -ForegroundColor Yellow
Write-Host "Expected format: https://xmhwyvojwukgowbhqhpo.supabase.co" -ForegroundColor Gray
Write-Host ""
$projectUrl = Read-Host "Project URL"

# Validate and fix URL
if (-not $projectUrl) {
    Write-Host "❌ URL cannot be empty!" -ForegroundColor Red
    exit 1
}

if ($projectUrl -eq "your-project-url-here" -or $projectUrl -match "your-project") {
    Write-Host "❌ You're still using the placeholder! Please enter your REAL Supabase URL." -ForegroundColor Red
    Write-Host "Get it from: https://supabase.com/dashboard/project/xmhwyvojwukgowbhqhpo/settings/api" -ForegroundColor Yellow
    exit 1
}

if (-not $projectUrl.StartsWith("https://")) {
    if ($projectUrl -match "^xmhwyvojwukgowbhqhpo") {
        $projectUrl = "https://$projectUrl.supabase.co"
        Write-Host "✅ Auto-corrected URL to: $projectUrl" -ForegroundColor Green
    } else {
        Write-Host "❌ URL must start with https://" -ForegroundColor Red
        exit 1
    }
}

# Get API Key
Write-Host ""
Write-Host "Step 2: Enter your Supabase anon/public API Key" -ForegroundColor Yellow
Write-Host "Get it from: https://supabase.com/dashboard/project/xmhwyvojwukgowbhqhpo/settings/api" -ForegroundColor Gray
Write-Host "Look for: Project API keys → anon → public (it's a long string starting with 'eyJ...')" -ForegroundColor Gray
Write-Host ""
$apiKey = Read-Host "API Key"

# Validate API Key
if (-not $apiKey) {
    Write-Host "❌ API key cannot be empty!" -ForegroundColor Red
    exit 1
}

if ($apiKey -eq "your-anon-key-here" -or $apiKey -match "your-anon") {
    Write-Host "❌ You're still using the placeholder! Please enter your REAL API key." -ForegroundColor Red
    Write-Host "Get it from: https://supabase.com/dashboard/project/xmhwyvojwukgowbhqhpo/settings/api" -ForegroundColor Yellow
    exit 1
}

if (-not $apiKey.StartsWith("eyJ")) {
    Write-Host "⚠️  Warning: API key should start with 'eyJ'. Are you sure this is correct?" -ForegroundColor Yellow
    $confirm = Read-Host "Continue anyway? (y/n)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 1
    }
}

# Create .env content
$envContent = @"
# Supabase Configuration
# Generated automatically - Do not commit this file to git

VITE_SUPABASE_URL=$projectUrl
VITE_SUPABASE_PUBLISHABLE_KEY=$apiKey
"@

# Backup old file
if (Test-Path .env) {
    $backupName = ".env.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item .env $backupName
    Write-Host ""
    Write-Host "✅ Backed up old .env to: $backupName" -ForegroundColor Green
}

# Write new file
try {
    $envContent | Out-File -FilePath .env -Encoding utf8 -NoNewline
    Write-Host ""
    Write-Host "✅ .env file updated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Updated values:" -ForegroundColor Cyan
    Write-Host "   URL: $projectUrl" -ForegroundColor White
    Write-Host "   Key: $($apiKey.Substring(0, [Math]::Min(50, $apiKey.Length)))..." -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "⚠️  IMPORTANT: RESTART YOUR DEV SERVER!" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Stop your current dev server (Ctrl+C)" -ForegroundColor Yellow
    Write-Host "2. Run: npm run dev" -ForegroundColor Yellow
    Write-Host "3. Test your application" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host "❌ Error updating .env file: $_" -ForegroundColor Red
    exit 1
}


