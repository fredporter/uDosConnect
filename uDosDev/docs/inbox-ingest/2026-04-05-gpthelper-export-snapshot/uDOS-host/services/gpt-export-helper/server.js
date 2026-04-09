import express from "express";
import fs from "fs";
import os from "os";
import path from "path";
import archiver from "archiver";
import { v4 as uuidv4 } from "uuid";

const app = express();

const PORT = process.env.PORT || 3000;
const PUBLIC_BASE_URL = process.env.PUBLIC_BASE_URL || `http://localhost:${PORT}`;
const EXPORT_TOKEN = process.env.EXPORT_TOKEN || "";
const OUTPUT_DIR = process.env.OUTPUT_DIR || path.join(os.homedir(), "udos-export-helper-exports");
const MAX_REQUEST_MB = Number(process.env.MAX_REQUEST_MB || 10);

if (!fs.existsSync(OUTPUT_DIR)) fs.mkdirSync(OUTPUT_DIR, { recursive: true });

app.use(express.json({ limit: `${MAX_REQUEST_MB}mb` }));

function authOk(req) {
  if (!EXPORT_TOKEN) return true;
  const authHeader = req.headers.authorization || "";
  return authHeader === `Bearer ${EXPORT_TOKEN}`;
}

function safeProjectName(name) {
  return String(name || "project")
    .replace(/[^a-zA-Z0-9-_]/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "")
    .toLowerCase() || "project";
}

app.get("/health", (_req, res) => {
  res.json({ ok: true, service: "udos-gpt-export-helper", version: "1.0.0" });
});

app.post("/export", async (req, res) => {
  try {
    if (!authOk(req)) return res.status(401).json({ ok: false, error: "unauthorized" });

    const { projectName, files } = req.body;
    if (!projectName || !Array.isArray(files) || files.length === 0) {
      return res.status(400).json({ ok: false, error: "projectName and files are required" });
    }

    const id = uuidv4();
    const safeName = safeProjectName(projectName);
    const folder = path.join(OUTPUT_DIR, `${safeName}-${id}`);
    fs.mkdirSync(folder, { recursive: true });

    for (const file of files) {
      if (!file?.path || typeof file.content !== "string") {
        return res.status(400).json({ ok: false, error: "each file requires path and content" });
      }

      const filePath = path.join(folder, file.path);
      const normalized = path.normalize(filePath);
      if (!normalized.startsWith(folder)) {
        return res.status(400).json({ ok: false, error: "invalid file path" });
      }

      fs.mkdirSync(path.dirname(normalized), { recursive: true });
      fs.writeFileSync(normalized, file.content, "utf8");
    }

    const zipPath = `${folder}.zip`;

    await new Promise((resolve, reject) => {
      const output = fs.createWriteStream(zipPath);
      const archive = archiver("zip", { zlib: { level: 9 } });
      output.on("close", resolve);
      archive.on("error", reject);
      archive.pipe(output);
      archive.directory(folder, safeName);
      archive.finalize();
    });

    res.json({
      ok: true,
      downloadUrl: `${PUBLIC_BASE_URL}/exports/${path.basename(zipPath)}`,
      localPath: zipPath
    });
  } catch (err) {
    res.status(500).json({ ok: false, error: String(err) });
  }
});

app.use("/exports", express.static(OUTPUT_DIR));

app.listen(PORT, () => {
  console.log(`uDOS GPT Export Helper running on http://localhost:${PORT}`);
});
