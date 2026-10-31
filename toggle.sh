#!/bin/sh
# Switch between v1 (blue) and v2 (red) for rehearsals and the live demo.
set -e
cd "$(dirname "$0")"
if grep -q '#2563eb' site/site.css; then
  sed -i 's/#2563eb/#dc2626/' site/site.css site/legacy.css
  sed -i 's/Build: v1/Build: v2/' site/index.template.html
  echo "Now v2 (red). Commit and push to deploy."
else
  sed -i 's/#dc2626/#2563eb/' site/site.css site/legacy.css
  sed -i 's/Build: v2/Build: v1/' site/index.template.html
  echo "Now v1 (blue). Commit and push to deploy."
fi
