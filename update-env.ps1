# PowerShell script to update .env file with Supabase credentials
# Usage: .\update-env.ps1

Write-Host "🔧 Supabase .env File Updater" -ForegroundColor Cyan
Write-Host ""

# Get Project URL
Write-Host "Enter your Supabase Project URL:" -ForegroundColor Yellow
Write-Host "Example: https://xmhwyvojwukgowbhqhpo.supabase.co" -ForegroundColor Gray
$projectUrl = Read-Host "Project URL"

# Validate URL
if (-not $projectUrl -or $projectUrl -eq "your-project-url-here") {
    Write-Host "❌ Invalid URL. Please enter a valid Supabase URL." -ForegroundColor Red
    exit 1
}

if (-not $projectUrl.StartsWith("https://")) {
    Write-Host "❌ URL must start with https://" -ForegroundColor Red
    exit 1
}

# Get API Key
Write-Host ""
Write-Host "Enter your Supabase anon/public key:" -ForegroundColor Yellow
Write-Host "You can find this at: https://supabase.com/dashboard/project/xmhwyvojwukgowbhqhpo/settings/api" -ForegroundColor Gray
Write-Host "Look for: Project API keys → anon → public" -ForegroundColor Gray
$apiKey = Read-Host "API Key"

# Validate API Key
if (-not $apiKey -or $apiKey -eq "your-anon-key-here") {
    Write-Host "❌ Invalid API key. Please enter your actual anon key." -ForegroundColor Red
    exit 1
}

if (-not $apiKey.StartsWith("eyJ")) {
    Write-Host "⚠️  Warning: API key should start with 'eyJ'. Are you sure this is correct?" -ForegroundColor Yellow
    $confirm = Read-Host "Continue anyway? (y/n)"
    if ($confirm -ne "y") {
        exit 1
    }
}

# Update .env file
$envContent = @"
# Supabase Configuration
# Get these values from: https://supabase.com/dashboard/project/xmhwyvojwukgowbhqhpo/settings/api

VITE_SUPABASE_URL=$projectUrl
VITE_SUPABASE_PUBLISHABLE_KEY=$apiKey
"@

try {
    $envContent | Out-File -FilePath .env -Encoding utf8 -NoNewline
    Write-Host ""
    Write-Host "✅ .env file updated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: You must restart your development server for changes to take effect!" -ForegroundColor Yellow
    Write-Host "   1. Stop your server (Ctrl+C)" -ForegroundColor Yellow
    Write-Host "   2. Run: npm run dev" -ForegroundColor Yellow
    Write-Host ""
} catch {
    Write-Host "❌ Error updating .env file: $_" -ForegroundColor Red
    exit 1
}


