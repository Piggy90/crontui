#!/usr/bin/env bash
# ==============================================================================
#  CRONTUI PUSH - Builds and publishes a staged release from backups
# ==============================================================================

set -e

# Ga naar de map van het script
cd "$(dirname "$0")"

VERSION=$1

if [ -z "$VERSION" ]; then
    # Auto-detecteer de laatste staged versie in backups/
    VERSION=$(ls -d backups/v*-pre-push 2>/dev/null | sort -V | tail -n 1 | grep -oP 'backups/v\K[0-9.]+-dev')
    if [ -z "$VERSION" ]; then
        echo "❌ No staged version found in backups/ and no version provided."
        echo "Usage: ./push.sh 1.1.2-dev"
        exit 1
    fi
    echo "🔍 No version provided, detected latest staged: $VERSION"
fi

CLEAN_VERSION=$(echo "$VERSION" | sed 's/-dev//')
STAGING_DIR="backups/v$VERSION-pre-push"

if [ ! -d "$STAGING_DIR" ]; then
    echo "❌ Staging directory $STAGING_DIR not found!"
    exit 1
fi

echo "🚀 Starting builds and push for version: $CLEAN_VERSION (from $VERSION source)"

GLOBAL_LOG="release.log"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] PUSH START: Version $VERSION (Clean: $CLEAN_VERSION)" >> "$GLOBAL_LOG"

# 1. Voer de tests uit in de staging directory
BUILD_LOG="$STAGING_DIR/build.log"
if [ -f "$STAGING_DIR/test.sh" ]; then
    echo "🧪 Running test suite in staging..."
    echo "🧪 Running test suite in staging..." >> "$BUILD_LOG"
    (cd "$STAGING_DIR" && ./test.sh) >> "$BUILD_LOG" 2>&1 || { echo "❌ Tests failed! Aborting release."; exit 1; }
fi

# 2. Synchroniseer versies naar builders in staging
echo "🔄 Synchronizing version numbers in staging..."
echo "🔄 Synchronizing version numbers in staging..." >> "$BUILD_LOG"
sed -i "s/VERSION=\"[0-9.]*\"/VERSION=\"$CLEAN_VERSION\"/" "$STAGING_DIR/build_deb.sh" >> "$BUILD_LOG" 2>&1
sed -i "s/pkgver=[0-9.]*/pkgver=$CLEAN_VERSION/" "$STAGING_DIR/APKBUILD" >> "$BUILD_LOG" 2>&1

# 3. Checksums bijwerken voor Alpine APKBUILD in staging
echo "📝 Updating SHA512 checksum in APKBUILD..."
echo "📝 Updating SHA512 checksum in APKBUILD..." >> "$BUILD_LOG"
sed -i '/^sha512sums="/,$d' "$STAGING_DIR/APKBUILD" >> "$BUILD_LOG" 2>&1
HASH=$(sha512sum "$STAGING_DIR/crontui" | awk '{print $1}')
cat << EOF >> "$STAGING_DIR/APKBUILD"

sha512sums="
${HASH}  crontui
"
EOF

# 4. Bouw Debian pakket (.deb) in staging
echo "📦 Building Debian package in staging..."
echo "📦 Building Debian package in staging..." >> "$BUILD_LOG"
(cd "$STAGING_DIR" && ./build_deb.sh) >> "$BUILD_LOG" 2>&1 || { echo "❌ Debian package build failed!"; exit 1; }

# 5. Bouw Alpine pakket (.apk) via Docker in staging
echo "📦 Building Alpine APK package via Docker in staging..."
echo "📦 Building Alpine APK package via Docker in staging..." >> "$BUILD_LOG"
rm -rf "$STAGING_DIR/x86_64" "$STAGING_DIR/noarch" "$STAGING_DIR/src" "$STAGING_DIR/pkg" "$STAGING_DIR/dist" >> "$BUILD_LOG" 2>&1
docker run --rm -v "$(pwd)/$STAGING_DIR":/work -w /work alpine:latest sh -c \
  "apk update && apk add --no-cache abuild alpine-sdk sudo && adduser -D builder && echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && addgroup builder abuild && chown -R builder /work && su builder -c 'abuild-keygen -a -i -n && REPODEST=/work abuild -r'" \
  >> "$BUILD_LOG" 2>&1 || { echo "❌ Alpine package build failed!"; exit 1; }

# Herstel eigendom van de bestanden op de host
chown -R "$(id -u)":"$(id -g)" "$STAGING_DIR" >> "$BUILD_LOG" 2>&1

# 6. Kopieer gebouwde artifacts en bijgewerkte files terug naar de root van de git repo
# Zodat de main branch van git ook de gebouwde release artifacts/config bevat
echo "🔄 Copying built files back to repository root..."
echo "🔄 Copying built files back to repository root..." >> "$BUILD_LOG"
cp "$STAGING_DIR/build_deb.sh" build_deb.sh >> "$BUILD_LOG" 2>&1
cp "$STAGING_DIR/APKBUILD" APKBUILD >> "$BUILD_LOG" 2>&1
cp "$STAGING_DIR/crontui_${CLEAN_VERSION}_all.deb" . 2>/dev/null >> "$BUILD_LOG" 2>&1 || true
mkdir -p x86_64 >> "$BUILD_LOG" 2>&1
cp "$STAGING_DIR/x86_64/crontui-${CLEAN_VERSION}-r0.apk" x86_64/ 2>/dev/null >> "$BUILD_LOG" 2>&1 || true

PUSH_LOG="$STAGING_DIR/push.log"
echo "=== CronTUI Push Log for v$CLEAN_VERSION ===" > "$PUSH_LOG"
echo "Push Date: $(date)" >> "$PUSH_LOG"
echo "============================================" >> "$PUSH_LOG"

# 7. Git push (commits en tags)
# Dit pusht de "Release vX.X.X" en de "chore: start dev cycle" commits, plus de tag vX.X.X
echo "📤 Pushing main branch and release tag v$CLEAN_VERSION to GitHub..."
echo "📤 Pushing main branch and release tag v$CLEAN_VERSION to GitHub..." >> "$PUSH_LOG"
git push origin main >> "$PUSH_LOG" 2>&1
git push origin "v$CLEAN_VERSION" --force >> "$PUSH_LOG" 2>&1

# 8. GitHub Release & Assets uploaden via Python script
echo "🐍 Creating GitHub Release and uploading assets..."
echo "🐍 Creating GitHub Release and uploading assets..." >> "$PUSH_LOG"
PYTHON_SCRIPT=$(mktemp)
cat << 'EOF' > "$PYTHON_SCRIPT"
import json
import urllib.request
import urllib.error
import os
import sys

token = os.environ.get("GITHUB_TOKEN")
if not token:
    token_file = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".github_token")
    if os.path.exists(token_file):
        with open(token_file, "r") as f:
            token = f.read().strip()
    else:
        # Check current directory fallback
        if os.path.exists(".github_token"):
            with open(".github_token", "r") as f:
                token = f.read().strip()

if not token:
    print("Error: GITHUB_TOKEN environment variable or .github_token file is missing.")
    sys.exit(1)

repo = "Piggy90/crontui"
version = sys.argv[1]
tag_name = f"v{version}"
release_name = f"CronTUI {tag_name}"
staging_dir = sys.argv[2]

# Lees release notes uit CHANGELOG.md van de staging directory
body = ""
try:
    with open(f"{staging_dir}/CHANGELOG.md", "r") as f:
        lines = f.readlines()
    started = False
    for line in lines:
        if line.startswith(f"## [{version}]") or line.startswith(f"## [v{version}]") or line.startswith(f"## {version}"):
            started = True
            body += line
            continue
        elif started and line.startswith("## "):
            break
        if started:
            body += line
except Exception as e:
    body = f"Release for version {version}"

# Maak GitHub release aan
release_url = f"https://api.github.com/repos/{repo}/releases"
headers = {
    "Authorization": f"token {token}",
    "Accept": "application/vnd.github.v3+json",
    "Content-Type": "application/json"
}

payload = {
    "tag_name": tag_name,
    "name": release_name,
    "body": body,
    "draft": False,
    "prerelease": False
}

print(f"Creating release {release_name}...")
req = urllib.request.Request(release_url, data=json.dumps(payload).encode('utf-8'), headers=headers, method="POST")
try:
    with urllib.request.urlopen(req) as resp:
        release_json = json.loads(resp.read().decode('utf-8'))
except urllib.error.HTTPError as e:
    # Als de release al bestaat, probeer de bestaande op te halen om assets te uploaden
    if e.code == 422:
        print("Release already exists. Fetching release info...")
        get_url = f"https://api.github.com/repos/{repo}/releases/tags/{tag_name}"
        get_req = urllib.request.Request(get_url, headers=headers)
        with urllib.request.urlopen(get_req) as resp:
            release_json = json.loads(resp.read().decode('utf-8'))
    else:
        print(f"HTTP Error: {e.code}")
        print(e.read().decode('utf-8'))
        sys.exit(1)

upload_base_url = release_json["upload_url"].split("{")[0]
assets = [
    {"path": f"{staging_dir}/crontui", "name": "crontui"},
    {"path": f"{staging_dir}/crontui_{version}_all.deb", "name": f"crontui_{version}_all.deb"},
    {"path": f"{staging_dir}/x86_64/crontui-{version}-r0.apk", "name": f"crontui-{version}-r0.apk"}
]

for asset in assets:
    file_path = asset["path"]
    file_name = asset["name"]
    if not os.path.exists(file_path):
        print(f"Warning: Asset not found at {file_path}")
        continue
    
    # Verwijder bestaande asset als die er al is
    if "assets" in release_json:
        for existing in release_json["assets"]:
            if existing["name"] == file_name:
                print(f"Deleting existing asset {file_name}...")
                del_req = urllib.request.Request(existing["url"], headers=headers, method="DELETE")
                urllib.request.urlopen(del_req)
                
    print(f"Uploading {file_name}...")
    with open(file_path, "rb") as f:
        data = f.read()
    
    upload_url = f"{upload_base_url}?name={file_name}"
    upload_headers = {
        "Authorization": f"token {token}",
        "Content-Type": "application/octet-stream",
        "Accept": "application/vnd.github.v3+json"
    }
    
    upload_req = urllib.request.Request(upload_url, data=data, headers=upload_headers, method="POST")
    with urllib.request.urlopen(upload_req) as u_resp:
        print(f"Uploaded {file_name} successfully!")

print("All assets uploaded successfully.")
EOF

python3 "$PYTHON_SCRIPT" "$CLEAN_VERSION" "$STAGING_DIR" >> "$PUSH_LOG" 2>&1
rm -f "$PYTHON_SCRIPT"

# 9. Homebrew Formula bijwerken
echo "🍺 Updating Homebrew Formula..."
echo "🍺 Updating Homebrew Formula..." >> "$PUSH_LOG"
# Genereer tijdelijke tarball om de SHA256 te bepalen van wat er in git staat
tar --exclude-vcs -czf "crontui-$CLEAN_VERSION.tar.gz" --transform "s|^|crontui-$CLEAN_VERSION/|" crontui LICENSE README.md Formula >> "$PUSH_LOG" 2>&1
BREW_SHA=$(sha256sum "crontui-$CLEAN_VERSION.tar.gz" | awk '{print $1}')
rm -f "crontui-$CLEAN_VERSION.tar.gz"

sed -i "s|url \".*\"|url \"https://github.com/Piggy90/crontui/archive/refs/tags/v$CLEAN_VERSION.tar.gz\"|" Formula/crontui.rb >> "$PUSH_LOG" 2>&1
sed -i "s|sha256 \".*\"|sha256 \"$BREW_SHA\"|" Formula/crontui.rb >> "$PUSH_LOG" 2>&1

echo "📤 Pushing Homebrew Formula update..." >> "$PUSH_LOG"
git add Formula/crontui.rb >> "$PUSH_LOG" 2>&1
if ! git diff --cached --quiet; then
    git commit -m "chore(release): update Homebrew formula for v$CLEAN_VERSION" >> "$PUSH_LOG" 2>&1
    git push origin main >> "$PUSH_LOG" 2>&1
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')] PUSH SUCCESS: Version $CLEAN_VERSION published to GitHub" >> "$GLOBAL_LOG"

echo "============================================================"
echo "✔ SUCCESS: CronTUI v$CLEAN_VERSION has been successfully released!"
echo "GitHub Release: https://github.com/Piggy90/crontui/releases/tag/v$CLEAN_VERSION"
echo "============================================================"
