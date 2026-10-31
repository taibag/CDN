#!/bin/sh
# Mini "@Assets": fingerprint site.css, leave legacy.css alone.
set -e
cd "$(dirname "$0")"
rm -rf dist && mkdir -p dist/assets dist/legacy
HASH=$(sha256sum site/site.css | cut -c1-8)
cp site/site.css "dist/assets/site.$HASH.css"
cp site/legacy.css dist/legacy/legacy.css
sed "s/__SITE_CSS__/site.$HASH.css/g" site/index.template.html > dist/index.html
cp _headers dist/_headers
echo "Built dist/ with assets/site.$HASH.css"
