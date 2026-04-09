# gpt-export-helper

Small Node service that packages GPT-generated files into ZIP archives.

## Setup
```bash
cp .env.example .env
npm install
npm start
```

## Early testing
```bash
ngrok http 3000
```

Then set:
- `PUBLIC_BASE_URL`
- OpenAPI `servers[0].url`
