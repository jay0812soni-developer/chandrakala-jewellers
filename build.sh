#!/bin/bash
set -e

echo "=============================================="
echo " ChandraKala Jewellers — Vercel Web Build CI"
echo "=============================================="

# 1. Setup Flutter SDK if not present in cache
if [ ! -d "$HOME/flutter" ]; then
  echo "Downloading Flutter SDK (stable channel)..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 $HOME/flutter
else
  echo "Using existing cached Flutter SDK"
fi

export PATH="$PATH:$HOME/flutter/bin"

echo "Flutter version:"
flutter --version

# 2. Install dependencies
echo "Running flutter pub get..."
flutter pub get

# 3. Build web release with CanvasKit and API URL injection
echo "Building Flutter Web release..."
API_URL="${API_URL:-https://cj-backend-kappa.vercel.app/api}"
CDN_BASE_URL="${CDN_BASE_URL:-https://chandrakalajewellers.in/uploads/}"
CATALOGUE_CDN_URL="${CATALOGUE_CDN_URL:-https://chandrakalajewellers.in/catalogue/}"

flutter build web --release \
  --dart-define=API_URL="$API_URL" \
  --dart-define=CDN_BASE_URL="$CDN_BASE_URL" \
  --dart-define=CATALOGUE_CDN_URL="$CATALOGUE_CDN_URL"

echo "=============================================="
echo " Build successful! Output located in build/web"
echo "=============================================="
