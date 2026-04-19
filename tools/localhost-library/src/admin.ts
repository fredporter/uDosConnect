// tools/localhost-library/src/admin.ts
// Admin Dashboard - Phase 8C

import express from 'express';
import path from 'path';
import fs from 'fs';
import chalk from 'chalk';
import { UserDatabase } from './db.js';

// Admin dashboard routes
function setupAdminRoutes(app: express.Application, userDb: UserDatabase, config: any) {
  
  // Admin dashboard - HTML page
  app.get('/admin', async (req, res) => {
    try {
      // In a real implementation, this would serve an HTML page
      // For now, return a simple message
      res.send(`
        <!DOCTYPE html>
        <html>
        <head>
          <title>uDosConnect Admin Dashboard</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            h1 { color: #2c3e50; }
            .info { background: #f8f9fa; padding: 20px; border-radius: 5px; }
          </style>
        </head>
        <body>
          <h1>🎛️ uDosConnect Admin Dashboard</h1>
          <div class="info">
            <p><strong>Status:</strong> Operational</p>
            <p><strong>Version:</strong> 1.0.0</p>
            <p><strong>Environment:</strong> Development</p>
          </div>
          <h2>Available Features</h2>
          <ul>
            <li>📋 User Management</li>
            <li>📰 Content Publishing</li>
            <li>🤖 Hivemind Monitoring</li>
            <li>🔧 System Settings</li>
          </ul>
          <p>This is a placeholder admin dashboard. Full implementation coming soon!</p>
        </body>
        </html>
      `);
    } catch (error: unknown) {
      console.error(chalk.red('❌ Admin dashboard error:'), error instanceof Error ? error.message : String(error));
      res.status(500).send('Admin dashboard error');
    }
  });

  // Admin API - User management
  app.get('/admin/api/users', async (req: any, res) => {
    try {
      const users = await userDb.listUsers();
      
      // Remove sensitive data
      const safeUsers = users.map(user => ({
        id: user.id,
        username: user.user_login,
        email: user.user_email,
        display_name: user.display_name,
        role: user.role,
        created_at: user.created_at
      }));

      res.json({
        success: true,
        users: safeUsers
      });
    } catch (error: unknown) {
      console.error(chalk.red('❌ User list error:'), error instanceof Error ? error.message : String(error));
      res.status(500).json({ error: 'Failed to fetch users' });
    }
  });

  // Admin API - System status
  app.get('/admin/api/status', async (req, res) => {
    try {
      const userCount = (await userDb.listUsers()).length;
      
      res.json({
        success: true,
        status: 'operational',
        users: userCount,
        timestamp: new Date().toISOString()
      });
    } catch (error: unknown) {
      console.error(chalk.red('❌ Status error:'), error instanceof Error ? error.message : String(error));
      res.status(500).json({ error: 'Failed to get status' });
    }
  });

  console.log(chalk.green('✅ Admin dashboard routes registered'));
}

export { setupAdminRoutes };