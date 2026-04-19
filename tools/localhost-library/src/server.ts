// tools/localhost-library/server.ts
// Localhost Library Web Server - Phase 8B

import express from 'express';
import path from 'path';
import fs from 'fs';
import cookieParser from 'cookie-parser';
import chalk from 'chalk';
import { fileURLToPath } from 'url';
import { UserDatabase } from './db.js';

// Get directory name for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configuration interface
interface ServerConfig {
  port: number;
  staticDir: string;
  templatesDir: string;
  baseUrl: string;
  jwtSecret: string;
  sessionSecret: string;
  dbPath: string;
}

// Default configuration
const DEFAULT_CONFIG: ServerConfig = {
  port: 8080,
  staticDir: '/srv/udos/www',
  templatesDir: path.join(__dirname, 'templates'),
  baseUrl: 'http://localhost:8080',
  jwtSecret: 'udos-default-secret-change-me',
  sessionSecret: 'udos-session-secret-change-me',
  dbPath: path.join(__dirname, 'users.db')
};

// Load configuration from environment variables
function loadConfig(): ServerConfig {
  const config: ServerConfig = { ...DEFAULT_CONFIG };

  if (process.env.PORT) {
    config.port = parseInt(process.env.PORT);
  }
  if (process.env.STATIC_DIR) {
    config.staticDir = process.env.STATIC_DIR;
  }
  if (process.env.BASE_URL) {
    config.baseUrl = process.env.BASE_URL;
  }
  if (process.env.JWT_SECRET) {
    config.jwtSecret = process.env.JWT_SECRET;
  }
  if (process.env.SESSION_SECRET) {
    config.sessionSecret = process.env.SESSION_SECRET;
  }
  if (process.env.DB_PATH) {
    config.dbPath = process.env.DB_PATH;
  }

  return config;
}

// Ensure directory exists
function ensureDirectory(dirPath: string): void {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

// Create Express application
async function createServer() {
  const config = loadConfig();
  
  console.log(chalk.cyan('🌐 Starting Localhost Library Web Server...'));
  console.log(chalk.blue(`📁 Static content: ${config.staticDir}`));
  console.log(chalk.blue(`🌐 Base URL: ${config.baseUrl}`));
  console.log(chalk.blue(`🔑 Port: ${config.port}`));

  // Initialize database
  const userDb = new UserDatabase(config.dbPath);
  await userDb.initialize();

  const app = express();

  // Middleware
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(cookieParser(config.sessionSecret));

  // Static file serving
  ensureDirectory(config.staticDir);
  app.use(express.static(config.staticDir, {
    maxAge: '1h',
    etag: true
  }));

  // Health check endpoint
  app.get('/health', (req, res) => {
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      version: '1.0.0'
    });
  });

  // Authentication routes
  app.post('/api/login', async (req, res) => {
    try {
      const { username, password } = req.body;
      
      if (!username || !password) {
        return res.status(400).json({ error: 'Username and password required' });
      }

      // Verify user credentials
      const isValid = await userDb.verifyPassword(username, password);
      
      if (!isValid) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      // Get user details
      const user = await userDb.findUserByLogin(username);
      
      if (!user) {
        return res.status(401).json({ error: 'User not found' });
      }

      // Update last seen
      await userDb.updateLastSeen(user.id!);

      // Create session (simplified for now)
      const sessionId = Math.random().toString(36).substring(2) + Date.now().toString(36);
      
      res.json({
        success: true,
        user: {
          id: user.id,
          username: user.user_login,
          role: user.role,
          email: user.user_email
        }
      });
    } catch (error: unknown) {
      console.error(chalk.red('❌ Login error:'), error instanceof Error ? error.message : String(error));
      res.status(500).json({ error: 'Authentication failed' });
    }
  });

  // User registration (admin only for now)
  app.post('/api/users', async (req, res) => {
    try {
      // TODO: Add admin check
      const { username, password, email, role = 'viewer' } = req.body;
      
      if (!username || !password) {
        return res.status(400).json({ error: 'Username and password required' });
      }

      // Check if user exists
      const existingUser = await userDb.findUserByLogin(username);
      if (existingUser) {
        return res.status(409).json({ error: 'Username already exists' });
      }

      // Create user
      const user = await userDb.createUser({
        user_login: username,
        user_pass: password,
        user_email: email,
        display_name: username,
        role: role as any
      });

      res.status(201).json({
        success: true,
        user: {
          id: user.id,
          username: user.user_login,
          role: user.role
        }
      });
    } catch (error: unknown) {
      console.error(chalk.red('❌ User creation error:'), error instanceof Error ? error.message : String(error));
      res.status(500).json({ error: 'User creation failed' });
    }
  });

  // Get current user (placeholder)
  app.get('/api/user', (req, res) => {
    // TODO: Implement session-based authentication
    res.json({ 
      user: null,
      authenticated: false,
      message: 'Authentication not yet implemented'
    });
  });

  // Basic API routes
  app.get('/api/status', (req, res) => {
    res.json({
      server: 'localhost-library',
      version: '1.0.0',
      features: ['static_serving', 'health_check', 'authentication']
    });
  });

  // 404 handler
  app.use((req, res) => {
    res.status(404).sendFile(path.join(config.staticDir, '404.html'));
  });

  // Error handler
  app.use((err: any, req: any, res: any, next: any) => {
    console.error(chalk.red('❌ Server error:'), err.message);
    res.status(500).json({
      error: 'Internal Server Error',
      message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
    });
  });

  // Start server
  const server = app.listen(config.port, () => {
    console.log(chalk.green(`✅ Server running on ${config.baseUrl}`));
    console.log(chalk.green(`📂 Serving static files from ${config.staticDir}`));
    console.log(chalk.green(`💾 Database: ${userDb.getDbPath()}`));
    console.log(chalk.cyan('\nAvailable endpoints:'));
    console.log(chalk.dim(`  • GET  /health - Health check`));
    console.log(chalk.dim(`  • GET  /api/status - Server status`));
    console.log(chalk.dim(`  • POST /api/login - User login`));
    console.log(chalk.dim(`  • POST /api/users - Create user`));
    console.log(chalk.dim(`  • GET  /api/user - Current user`));
    console.log(chalk.dim(`  • GET  /* - Static file serving`));
  });

  // Handle graceful shutdown
  process.on('SIGINT', () => {
    console.log(chalk.yellow('\n🛑 Shutting down server...'));
    server.close(() => {
      console.log(chalk.yellow('✅ Server stopped'));
      process.exit(0);
    });
  });

  return app;
}

// Export server creation function
export { createServer, loadConfig };

// Start server if run directly
if (import.meta.url === `file://${process.argv[1]}`) {
  createServer().catch(err => {
    console.error(chalk.red('❌ Failed to start server:'), err);
    process.exit(1);
  });
}