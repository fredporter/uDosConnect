/**
 * uDos Network Manager
 * LAN interface detection, health monitoring, and fallback mechanisms
 * Part of Cycle 1, Round 2: LAN & Network Resilience
 */

import { exec } from 'node:child_process';
import { promisify } from 'node:util';
import os from 'node:os';
import fs from 'fs-extra';
import chalk from 'chalk';

const execAsync = promisify(exec);

/**
 * Network Interface
 */
export interface NetworkInterface {
  name: string;
  type: 'wired' | 'wireless' | 'virtual' | 'unknown';
  ipv4: string[];
  ipv6: string[];
  mac: string;
  status: 'up' | 'down' | 'unknown';
}

/**
 * Network Manager
 * Handles LAN interface detection, health monitoring, and fallback
 */
export class NetworkManager {
  private interfaces: NetworkInterface[] = [];
  private fallbackIP: string = '192.168.1.100';
  private healthCheckInterval: number = 30000; // 30 seconds
  private healthCheckTimer: NodeJS.Timeout | null = null;

  constructor() {
    this.loadInterfaces();
  }

  /**
   * Load all network interfaces
   */
  private async loadInterfaces(): Promise<void> {
    try {
      const { networkInterfaces } = os;
      this.interfaces = Object.entries(networkInterfaces())
        .filter(([name, iface]) => {
          // Filter out internal and non-IP interfaces
          return iface && (iface.ipv4 || iface.ipv6) && !name.startsWith('lo');
        })
        .map(([name, iface]) => ({
          name,
          type: this.getInterfaceType(iface),
          ipv4: iface.ipv4 || [],
          ipv6: iface.ipv6 || [],
          mac: iface.mac || '00:00:00:00:00:00',
          status: 'unknown'
        }));
      
      console.log(chalk.blue('Network interfaces loaded:'));
      this.interfaces.forEach(iface => {
        console.log(`  ${iface.name}: ${iface.ipv4.join(', ')} (${iface.type})`);
      });
    } catch (error) {
      console.error(chalk.red('Error loading network interfaces:'), error);
    }
  }

  /**
   * Determine interface type
   */
  private getInterfaceType(iface: any): 'wired' | 'wireless' | 'virtual' | 'unknown' {
    if (iface.internal) return 'virtual';
    if (iface.wireless) return 'wireless';
    return 'wired';
  }

  /**
   * Start health monitoring
   */
  public startMonitoring(): void {
    if (this.healthCheckTimer) {
      clearInterval(this.healthCheckTimer);
    }
    
    this.healthCheckTimer = setInterval(async () => {
      try {
        await this.checkInterfaceHealth();
      } catch (error) {
        console.error(chalk.red('Health check failed:'), error);
      }
    }, this.healthCheckInterval);
    
    console.log(chalk.green(`Network health monitoring started (${this.healthCheckInterval/1000}s interval)`));
  }

  /**
   * Stop health monitoring
   */
  public stopMonitoring(): void {
    if (this.healthCheckTimer) {
      clearInterval(this.healthCheckTimer);
      this.healthCheckTimer = null;
      console.log(chalk.yellow('Network health monitoring stopped'));
    }
  }

  /**
   * Check health of all interfaces
   */
  private async checkInterfaceHealth(): Promise<void> {
    for (const iface of this.interfaces) {
      try {
        // Ping test for wired/wireless interfaces
        if (iface.type !== 'virtual') {
          const pingResult = await this.pingTest(iface.ipv4[0]);
          iface.status = pingResult ? 'up' : 'down';
        }
      } catch (error) {
        console.error(chalk.red(`Health check failed for ${iface.name}:`), error);
        iface.status = 'down';
      }
    }
    
    // Log health status
    this.logHealthStatus();
  }

  /**
   * Ping test helper
   */
  private async pingTest(ip: string): Promise<boolean> {
    try {
      // Simple ping test (cross-platform)
      const { stdout } = await execAsync(`ping -c 1 ${ip}`);
      return stdout.includes('bytes from') || stdout.includes('reply from');
    } catch (error) {
      return false;
    }
  }

  /**
   * Log current health status
   */
  private logHealthStatus(): void {
    console.log(chalk.blue('Network Health Status:'));
    this.interfaces.forEach(iface => {
      const statusIcon = iface.status === 'up' ? chalk.green('✓') : chalk.red('✗');
      console.log(`  ${statusIcon} ${iface.name}: ${iface.status}`);
    });
  }

  /**
   * Get active interface for fallback
   */
  public getActiveInterface(): NetworkInterface | null {
    return this.interfaces.find(iface => iface.status === 'up') || null;
  }

  /**
   * Get fallback IP
   */
  public getFallbackIP(): string {
    return this.fallbackIP;
  }

  /**
   * Set fallback IP
   */
  public setFallbackIP(ip: string): void {
    this.fallbackIP = ip;
    console.log(chalk.green(`Fallback IP set to: ${ip}`));
  }
}

// Export singleton
export const networkManager = new NetworkManager();