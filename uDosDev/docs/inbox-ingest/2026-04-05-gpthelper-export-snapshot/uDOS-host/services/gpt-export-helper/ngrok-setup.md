# ngrok Setup

## Start the helper
```bash
npm start
```

## Expose port 3000
```bash
ngrok http 3000
```

## Copy the HTTPS URL

Use it in two places:
1. `.env` → `PUBLIC_BASE_URL`
2. `uDOS-gpthelper/actions/export-openapi.json` → `servers[0].url`
