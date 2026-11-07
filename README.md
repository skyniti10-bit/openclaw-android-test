# Railway OpenClaw upgrade candidate — isolated Git branch

**Status: candidate only; do not deploy until Railway /data volume backup is verified.**

Source wrapper: https://github.com/vignesh07/clawdbot-railway-template/tree/b9e2467189d02dfe51a80173c40bad650a58eaf2 (MIT license, retained).
The original Android branch `main` is not modified. This is an isolated branch for Railway OpenClaw, not an Android APK build.

- OpenClaw: official published npm package **2026.11.1** (fixed version; no floating `latest`)
- Runtime: Node.js 26 (required by OpenClaw package engines)
- Wrapper: exact source files from upstream commit b9e2467189d02dfe51a80173c40bad650a58eaf2
- Existing Railway service/port: HTTP 8080; upstream gateway internal 18789
- Existing persistent storage: original Railway volume mounted at **/data** (not copied or recreated)
- No credentials / OAuth links / API keys checked into this repository
- Device-code login after upgrade: `openclaw models auth login --provider openai --method device-code`
- Technical preflight: npm package must contain `dist/entry.js`; Docker build fails rather than deploying a broken wrapper otherwise
- Backup: create a manual Railway volume backup **before** committing the staged source switch
- Rollback: reconnect source to `vignesh07/clawdbot-railway-template` (original source commit `b9e2467189d02dfe51a80173c40bad650a58eaf2`) and redeploy the known-good build. Database/config migrations may make a code-only rollback insufficient, so restore the pre-upgrade volume snapshot if required.

No automatic GitHub Actions workflow is included; build/deploy requires explicit action.
