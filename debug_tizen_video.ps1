# Tizen Video Debug Script (PowerShell)
# Untuk debugging video player di Tizen OS

Write-Host "🔍 Tizen Video Player Debugging Tool" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check video file
Write-Host "1️⃣ Checking video file..." -ForegroundColor Yellow
$VIDEO_PATH = "assets\rumah\harmoni_106_112.mp4"

if (Test-Path $VIDEO_PATH) {
    Write-Host "   ✅ Video file exists: $VIDEO_PATH" -ForegroundColor Green
    
    $fileSize = (Get-Item $VIDEO_PATH).Length / 1MB
    Write-Host "   📦 File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor White
} else {
    Write-Host "   ❌ Video file NOT found: $VIDEO_PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2️⃣ Checking pubspec.yaml..." -ForegroundColor Yellow
$pubspecContent = Get-Content "pubspec.yaml" -Raw
if ($pubspecContent -match "harmoni_106_112.mp4") {
    Write-Host "   ✅ Video registered in pubspec.yaml" -ForegroundColor Green
} else {
    Write-Host "   ❌ Video NOT registered in pubspec.yaml" -ForegroundColor Red
    Write-Host "   Add this to pubspec.yaml assets section:" -ForegroundColor Yellow
    Write-Host "   - assets/rumah/harmoni_106_112.mp4" -ForegroundColor White
}

Write-Host ""
Write-Host "3️⃣ Checking video_player dependencies..." -ForegroundColor Yellow
if ($pubspecContent -match "video_player_tizen") {
    Write-Host "   ✅ video_player_tizen found" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  video_player_tizen not found in pubspec.yaml" -ForegroundColor Yellow
}

if ($pubspecContent -match "video_player:") {
    Write-Host "   ✅ video_player found" -ForegroundColor Green
} else {
    Write-Host "   ❌ video_player not found in pubspec.yaml" -ForegroundColor Red
}

Write-Host ""
Write-Host "4️⃣ Build and Run Commands:" -ForegroundColor Yellow
Write-Host "   Build TPK:" -ForegroundColor White
Write-Host "   PS> flutter-tizen build tpk" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Run on device:" -ForegroundColor White
Write-Host "   PS> flutter-tizen run" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Clean build:" -ForegroundColor White
Write-Host "   PS> flutter-tizen clean" -ForegroundColor Cyan
Write-Host "   PS> flutter-tizen pub get" -ForegroundColor Cyan
Write-Host "   PS> flutter-tizen build tpk" -ForegroundColor Cyan

Write-Host ""
Write-Host "5️⃣ Debugging Tips:" -ForegroundColor Yellow
Write-Host "   • Check console for '🎬 Initializing video(s)...' message" -ForegroundColor White
Write-Host "   • Look for 'Platform: linux' (Tizen runs on Linux)" -ForegroundColor White
Write-Host "   • Check if '🔧 Tizen: Triggering first frame render...' appears" -ForegroundColor White
Write-Host "   • Watch for any error messages during initialization" -ForegroundColor White
Write-Host "   • If video still blank, video format might be incompatible" -ForegroundColor White

Write-Host ""
Write-Host "6️⃣ Video Format Requirements for Tizen:" -ForegroundColor Yellow
Write-Host "   • Container: MP4" -ForegroundColor White
Write-Host "   • Video Codec: H.264 (baseline profile preferred)" -ForegroundColor White
Write-Host "   • Audio Codec: AAC" -ForegroundColor White
Write-Host "   • Resolution: ≤ 1920x1080" -ForegroundColor White
Write-Host "   • Frame Rate: 30fps or 60fps" -ForegroundColor White

Write-Host ""
Write-Host "✅ Diagnostic complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run: flutter-tizen run" -ForegroundColor White
Write-Host "2. Navigate to a product with video (e.g., Harmoni 100/108)" -ForegroundColor White
Write-Host "3. Check console output for debugging info" -ForegroundColor White
Write-Host "4. Swipe to video item in carousel" -ForegroundColor White
Write-Host "5. Tap video to play/pause and observe behavior" -ForegroundColor White
