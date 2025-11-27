#!/bin/bash

# Tizen Video Debug Script
# Untuk debugging video player di Tizen OS

echo "🔍 Tizen Video Player Debugging Tool"
echo "===================================="
echo ""

# Check video file
echo "1️⃣ Checking video file..."
VIDEO_PATH="assets/rumah/harmoni_106_112.mp4"

if [ -f "$VIDEO_PATH" ]; then
    echo "   ✅ Video file exists: $VIDEO_PATH"
    
    # Get file info
    FILE_SIZE=$(du -h "$VIDEO_PATH" | cut -f1)
    echo "   📦 File size: $FILE_SIZE"
    
    # Check video properties (if ffprobe is available)
    if command -v ffprobe &> /dev/null; then
        echo ""
        echo "   📹 Video properties:"
        ffprobe -v quiet -print_format json -show_format -show_streams "$VIDEO_PATH" | grep -E '"codec_name"|"width"|"height"|"duration"|"bit_rate"' | head -6
    else
        echo "   ℹ️  Install ffmpeg to see video details"
    fi
else
    echo "   ❌ Video file NOT found: $VIDEO_PATH"
    exit 1
fi

echo ""
echo "2️⃣ Checking pubspec.yaml..."
if grep -q "assets/rumah/harmoni_106_112.mp4" pubspec.yaml; then
    echo "   ✅ Video registered in pubspec.yaml"
else
    echo "   ❌ Video NOT registered in pubspec.yaml"
    echo "   Add this to pubspec.yaml assets section:"
    echo "   - assets/rumah/harmoni_106_112.mp4"
fi

echo ""
echo "3️⃣ Checking video_player dependencies..."
if grep -q "video_player_tizen" pubspec.yaml; then
    echo "   ✅ video_player_tizen found"
else
    echo "   ⚠️  video_player_tizen not found in pubspec.yaml"
fi

if grep -q "video_player:" pubspec.yaml; then
    echo "   ✅ video_player found"
else
    echo "   ❌ video_player not found in pubspec.yaml"
fi

echo ""
echo "4️⃣ Build and Run Commands:"
echo "   Build TPK:"
echo "   $ flutter-tizen build tpk"
echo ""
echo "   Run on device:"
echo "   $ flutter-tizen run"
echo ""
echo "   Clean build:"
echo "   $ flutter-tizen clean"
echo "   $ flutter-tizen pub get"
echo "   $ flutter-tizen build tpk"

echo ""
echo "5️⃣ Debugging Tips:"
echo "   • Check console for '🎬 Initializing video(s)...' message"
echo "   • Look for 'Platform: linux' (Tizen runs on Linux)"
echo "   • Check if '🔧 Tizen: Triggering first frame render...' appears"
echo "   • Watch for any error messages during initialization"
echo "   • If video still blank, try converting format:"
echo "     $ ffmpeg -i input.mp4 -c:v libx264 -profile:v baseline -c:a aac output.mp4"

echo ""
echo "✅ Diagnostic complete!"
