# Cache demo (CDN and caching)

Two boxes, two kinds of CSS file:

- **Box A**: `site.css` is copied to `assets/site.<hash>.css` at build time. The name changes when the content changes, so it is cached for a year (`immutable`).
- **Box B**: `legacy.css` keeps the same name and is cached for 1 hour. After a deploy, people who already loaded it keep the old color.
- **HTML**: `no-cache`, so every normal page load gets the latest HTML.

Headers are defined in `_headers` (Netlify reads it from the published folder).

## Files

| File | Role |
|---|---|
| `site/` | Source: page template and the two CSS files |
| `build.sh` | Builds `dist/` and fingerprints `site.css` |
| `toggle.sh` | Switches v1 (blue) and v2 (red), for rehearsals and the live demo |
| `_headers` | Cache-Control rules for Netlify |
| `.github/workflows/deploy.yml` | Gitleaks, build, deploy to Netlify |
| `netlify.toml` | Only needed if you connect the repo directly in Netlify instead |

## Setup

1. Create a **public** GitHub repo and push this folder to branch `main`.
2. In Netlify, create a site by deploying manually (any small folder works at first). Copy its **Site ID**.
3. In Netlify user settings, create a **personal access token**.
4. In GitHub, go to Settings, Secrets and variables, Actions, and add `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID`.
5. Push to `main`. The workflow scans, builds and deploys.

Use either the workflow or Netlify's own GitHub link, not both, or every push deploys twice.

## Check the headers

```bash
URL=https://YOUR-SITE.netlify.app
curl -s -D - -o /dev/null $URL/ | grep -i -E 'cache-control|etag|age|cache-status'
curl -s $URL/ | grep -i stylesheet
curl -s -D - -o /dev/null $URL/assets/site.HASH.css | grep -i cache-control
curl -s -D - -o /dev/null $URL/legacy/legacy.css | grep -i cache-control
```

## Live demo

1. Everyone opens the link (blue boxes).
2. `sh toggle.sh`, commit, push, and wait for the workflow to finish.
3. Everyone reloads by pressing Enter in the address bar, not Ctrl+F5.
4. Box A turns red. Box B stays blue for people who loaded it earlier.

Rehearse this at least three times on the same kind of devices and network.
