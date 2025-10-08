#!/usr/bin/env bash
# Install GraphicsMagick and Ghostscript for PDF processing
set -e

echo "📦 Installing system dependencies for PDF processing..."

# Install GraphicsMagick and Ghostscript
apt-get update
apt-get install -y graphicsmagick ghostscript

echo "✅ System dependencies installed"

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install
npm run build

# Push database schema
echo "🗄️  Pushing database schema..."
npm run db:push

echo "✅ Build complete!"
