#!/usr/bin/env bash
# ==============================================================================
#  CRONTUI PRE-BUILD - Stages a version for release
# ==============================================================================

set -e

# Ga naar de map van het script
cd "$(dirname "$0")"

# 1. Detecteer versie uit crontui script
VERSION=$(grep -oP "echo \"CronTUI v\K[0-9.]+(-dev)?" crontui)
if [ -z "$VERSION" ]; then
    echo "❌ Could not detect version from crontui script"
    exit 1
fi

if [[ "$VERSION" != *"-dev"* ]]; then
    echo "❌ Active version $VERSION is not a development version (does not end with -dev)."
    echo "   To start a new cycle, set version in crontui to X.Y.Z-dev first."
    exit 1
fi

CLEAN_VERSION=$(echo "$VERSION" | sed 's/-dev//')
echo "🚀 Processing version: $VERSION (Clean Release: $CLEAN_VERSION)"

# 2. Maak de staging directory aan
STAGING_DIR="backups/v$VERSION-pre-push"
echo "📦 Creating staging directory: $STAGING_DIR"
mkdir -p "$STAGING_DIR"

# 3. Kopieer benodigde bestanden naar de staging directory
echo "🔄 Copying source files to staging..."
cp crontui CHANGELOG.md README.md LICENSE APKBUILD build_deb.sh release.sh test.sh "$STAGING_DIR/"
if [ -d "Formula" ]; then
    cp -r Formula "$STAGING_DIR/"
fi

# 4. Pas in de staging directory de bestanden aan voor clean release
echo "🧹 Adjusting versions in staging to clean release ($CLEAN_VERSION)..."
sed -i "s/echo \"CronTUI v$VERSION\"/echo \"CronTUI v$CLEAN_VERSION\"/" "$STAGING_DIR/crontui"
sed -i "s/## \[$VERSION\]/## \[$CLEAN_VERSION\]/g" "$STAGING_DIR/CHANGELOG.md"

# 5. Voer lokale commit en tag uit voor de clean release
# Zorg dat de clean release lokaal gecommit en getagd is in git
echo "📝 Creating local git commit and tag for v$CLEAN_VERSION..."
# We kopiëren tijdelijk de clean bestanden naar de root om ze te committen en te taggen
# Dit zorgt ervoor dat de git geschiedenis exact de clean release bevat
cp "$STAGING_DIR/crontui" crontui
cp "$STAGING_DIR/CHANGELOG.md" CHANGELOG.md

git add crontui CHANGELOG.md
git commit -m "Release v$CLEAN_VERSION"

# Controleer of tag al bestaat en verwijder lokaal indien nodig
if git rev-parse "v$CLEAN_VERSION" >/dev/null 2>&1; then
    echo "⚠️ Tag v$CLEAN_VERSION exists locally. Replacing..."
    git tag -d "v$CLEAN_VERSION"
fi
git tag -a "v$CLEAN_VERSION" -m "CronTUI v$CLEAN_VERSION — Release"

# 6. Auto-bump de actieve dev-versie in de root voor de volgende cyclus
BASE_VERSION=$(echo "$CLEAN_VERSION" | cut -d. -f1,2)
PATCH_VERSION=$(echo "$CLEAN_VERSION" | cut -d. -f3)
NEW_PATCH=$((PATCH_VERSION + 1))
NEXT_DEV_VERSION="${BASE_VERSION}.${NEW_PATCH}-dev"

echo "📈 Auto-bumping local development version to $NEXT_DEV_VERSION..."
sed -i "s/echo \"CronTUI v$CLEAN_VERSION\"/echo \"CronTUI v$NEXT_DEV_VERSION\"/" crontui

# Voeg een placeholder toe aan CHANGELOG.md in de root
if ! grep -q "\[$NEXT_DEV_VERSION\]" CHANGELOG.md; then
    # Voeg in na de header (regel 10)
    sed -i "10i ## [$NEXT_DEV_VERSION] - $(date +%Y-%m-%d)\n\n### Added\n- Work in progress for next release.\n" CHANGELOG.md
fi

# Commit de start van de nieuwe dev cyclus lokaal
git add crontui CHANGELOG.md
git commit -m "chore: start dev cycle for v$NEXT_DEV_VERSION"

echo "============================================================"
echo "✔ SUCCESS: Pre-build staging complete!"
echo "Staged path: $STAGING_DIR"
echo "Local repository is now on development version: $NEXT_DEV_VERSION"
echo "👉 Review the files in $STAGING_DIR. When ready to publish to GitHub:"
echo "   Run: ./push.sh $VERSION"
echo "============================================================"
