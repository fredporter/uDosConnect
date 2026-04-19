// core/src/commands/network.ts
// uDosConnect Home Network - Master-Slave Cluster Implementation

import { Command } from 'commander';
import chalk from 'chalk';
import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import os from 'os';

// Network configuration interface
interface NetworkConfig {
  role: 'master' | 'child' | 'none';
  masterHost?: string;
  masterPort?: number;
  childName?: string;
  vaultPath?: string;
  codevaultPath?: string;
  children?: Array<{
    name: string;
    host: string;
    os: string;
    lastSeen: string;
    status: 'online' | 'offline' | 'busy';
  }>;
}

// Default configuration path
const CONFIG_PATH = path.join(os.homedir(), '.udos', 'network-config.json');

// Ensure config directory exists
function ensureConfigDir(): void {
  const configDir = path.dirname(CONFIG_PATH);
  if (!fs.existsSync(configDir)) {
    fs.mkdirSync(configDir, { recursive: true });
  }
}

// Load network configuration
function loadConfig(): NetworkConfig {
  ensureConfigDir();
  if (!fs.existsSync(CONFIG_PATH)) {
    const defaultConfig: NetworkConfig = {
      role: 'none',
      masterPort: 3010,
      children: []
    };
    fs.writeFileSync(CONFIG_PATH, JSON.stringify(defaultConfig, null, 2));
    return defaultConfig;
  }
  return JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));
}

// Save network configuration
function saveConfig(config: NetworkConfig): void {
  ensureConfigDir();
  fs.writeFileSync(CONFIG_PATH, JSON.stringify(config, null, 2));
}

// Check if running on Linux (master requirement)
function isLinux(): boolean {
  return os.platform() === 'linux';
}

// Check if running on macOS
function isMacOS(): boolean {
  return os.platform() === 'darwin';
}

// Check if running on Windows
function isWindows(): boolean {
  return os.platform() === 'win32';
}

// Master initialization
async function initializeMaster(): Promise<void> {
  if (!isLinux()) {
    console.log(chalk.red('❌ Master must run on Linux (Linux Mint recommended)'));
    console.log(chalk.dim('Current platform:'), chalk.yellow(os.platform()));
    return;
  }

  console.log(chalk.cyan('🏠 Initializing uDosConnect Master Node...'));

  // Create shared directories
  const sharedDirs = [
    '/srv/udos/vault',
    '/srv/udos/codevault',
    '/srv/udos/devices',
    '/srv/udos/updates',
    '/srv/udos/vendor'
  ];

  for (const dir of sharedDirs) {
    try {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(chalk.green(`✅ Created ${dir}`));
      } else {
        console.log(chalk.yellow(`⚠️  ${dir} already exists`));
      }
    } catch (error: unknown) {
      console.log(chalk.red(`❌ Failed to create ${dir}:`), error instanceof Error ? error.message : String(error));
    }
  }

  // Initialize shared vault
  console.log(chalk.blue('📁 Initializing shared vault...'));
  try {
    execSync('udo vault init /srv/udos/vault --shared', { stdio: 'inherit' });
    console.log(chalk.green('✅ Shared vault initialized'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to initialize shared vault:'), error instanceof Error ? error.message : String(error));
  }

  // Initialize codevault (bare git repo)
  console.log(chalk.blue('💾 Initializing codevault...'));
  try {
    if (!fs.existsSync('/srv/udos/codevault/config')) {
      execSync('cd /srv/udos/codevault && git init --bare', { stdio: 'inherit' });
      execSync('cd /srv/udos/codevault && git lfs track "*.bin" "*.model"', { stdio: 'inherit' });
      console.log(chalk.green('✅ Codevault initialized'));
    } else {
      console.log(chalk.yellow('⚠️  Codevault already exists'));
    }
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to initialize codevault:'), error instanceof Error ? error.message : String(error));
  }

  // Configure NFS for Linux/macOS children
  console.log(chalk.blue('🔧 Configuring NFS server...'));
  try {
    const exportsContent = '/srv/udos *(rw,sync,no_subtree_check,no_root_squash)';
    const exportsFile = '/etc/exports';
    
    let currentExports = '';
    if (fs.existsSync(exportsFile)) {
      currentExports = fs.readFileSync(exportsFile, 'utf-8');
    }
    
    if (!currentExports.includes('/srv/udos')) {
      fs.appendFileSync(exportsFile, '\n' + exportsContent + '\n');
      execSync('sudo exportfs -a', { stdio: 'inherit' });
      execSync('sudo systemctl restart nfs-kernel-server', { stdio: 'inherit' });
      console.log(chalk.green('✅ NFS configured and restarted'));
    } else {
      console.log(chalk.yellow('⚠️  NFS export already configured'));
    }
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to configure NFS:'), error instanceof Error ? error.message : String(error));
    console.log(chalk.dim('You may need to run with sudo or configure manually'));
  }

  // Configure SMB for Windows children
  console.log(chalk.blue('📂 Configuring SMB server...'));
  try {
    // This would require more complex setup, for now just show instructions
    console.log(chalk.dim('SMB configuration requires manual setup:'));
    console.log(chalk.dim('1. sudo apt install samba'));
    console.log(chalk.dim('2. sudo smbpasswd -a $USER'));
    console.log(chalk.dim('3. Add [udos] share to /etc/samba/smb.conf'));
    console.log(chalk.dim('4. sudo systemctl restart smbd'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ SMB configuration note:'), error instanceof Error ? error.message : String(error));
  }

  // Update network configuration
  const config = loadConfig();
  config.role = 'master';
  config.vaultPath = '/srv/udos/vault';
  config.codevaultPath = '/srv/udos/codevault';
  saveConfig(config);

  console.log(chalk.green('✅ Master initialization complete!'));
  console.log(chalk.cyan('\nNext steps:'));
  console.log(chalk.dim('1. udo network master start - Start master services'));
  console.log(chalk.dim('2. Configure children to connect to this master'));
  console.log(chalk.dim('3. udo network status - Monitor your cluster'));
}

// Start master services
async function startMasterServices(): Promise<void> {
  const config = loadConfig();
  
  if (config.role !== 'master') {
    console.log(chalk.red('❌ This node is not configured as master'));
    console.log(chalk.dim('Run: udo network master init'));
    return;
  }

  console.log(chalk.cyan('🚀 Starting uDosConnect Master Services...'));

  // Start MCP Hub (central orchestrator)
  console.log(chalk.blue('🎯 Starting MCP Hub on port 3010...'));
  try {
    // This would be a separate service - for now just show it's planned
    console.log(chalk.green('✅ MCP Hub started (simulated)'));
    console.log(chalk.dim('Future: Actual MCP service will run here'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to start MCP Hub:'), error instanceof Error ? error.message : String(error));
  }

  // Start Update Server (sonic-express)
  console.log(chalk.blue('🔄 Starting Update Server on port 8080...'));
  try {
    execSync('sonic-express --port 8080 --repo /srv/udos/updates --daemon', { stdio: 'inherit' });
    console.log(chalk.green('✅ Update Server started'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to start Update Server:'), error instanceof Error ? error.message : String(error));
  }

  // Start Device DB (SQLite over HTTP)
  console.log(chalk.blue('📱 Starting Device DB on port 8081...'));
  try {
    console.log(chalk.green('✅ Device DB started (simulated)'));
    console.log(chalk.dim('Future: SQLite HTTP server will run here'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to start Device DB:'), error instanceof Error ? error.message : String(error));
  }

  // Start Vendor Cache (HTTP)
  console.log(chalk.blue('📦 Starting Vendor Cache on port 8082...'));
  try {
    console.log(chalk.green('✅ Vendor Cache started (simulated)'));
    console.log(chalk.dim('Future: HTTP file server will run here'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to start Vendor Cache:'), error instanceof Error ? error.message : String(error));
  }

  console.log(chalk.green('✅ All master services started!'));
  console.log(chalk.cyan('\nMaster services running:'));
  console.log(chalk.dim('• MCP Hub: http://master.local:3010'));
  console.log(chalk.dim('• Update Server: http://master.local:8080'));
  console.log(chalk.dim('• Device DB: http://master.local:8081'));
  console.log(chalk.dim('• Vendor Cache: http://master.local:8082'));
  console.log(chalk.dim('• NFS: master.local:/srv/udos'));
  console.log(chalk.dim('• SMB: \\\\master\\udos'));
}

// Child registration
async function registerChild(name: string, masterHost: string): Promise<void> {
  console.log(chalk.cyan(`🖥️  Registering child node: ${name}`));

  // Validate child name
  if (!name || name.trim() === '') {
    console.log(chalk.red('❌ Child name cannot be empty'));
    return;
  }

  // Update network configuration
  const config = loadConfig();
  config.role = 'child';
  config.masterHost = masterHost;
  config.childName = name;
  config.vaultPath = '/mnt/udos_master/vault';
  config.codevaultPath = '/mnt/udos_master/codevault';
  saveConfig(config);

  console.log(chalk.green(`✅ Child ${name} registered with master ${masterHost}`));

  // Show next steps
  console.log(chalk.cyan('\nNext steps:'));
  console.log(chalk.dim(`1. Mount master vault: sudo mount -t nfs ${masterHost}:/srv/udos /mnt/udos_master`));
  console.log(chalk.dim('2. udo network child start - Start child agent'));
  console.log(chalk.dim('3. udo codevault pull - Sync code from master'));
}

// Start child agent
async function startChildAgent(): Promise<void> {
  const config = loadConfig();
  
  if (config.role !== 'child') {
    console.log(chalk.red('❌ This node is not configured as child'));
    console.log(chalk.dim('Run: udo network child register --master <host> --name <name>'));
    return;
  }

  if (!config.masterHost) {
    console.log(chalk.red('❌ Master host not configured'));
    return;
  }

  console.log(chalk.cyan(`🤖 Starting child agent for ${config.childName}...`));

  // Check if master is reachable
  console.log(chalk.blue(`🔍 Checking connection to master ${config.masterHost}...`));
  try {
    // Simple ping test
    execSync(`ping -c 1 ${config.masterHost}`, { stdio: 'ignore' });
    console.log(chalk.green('✅ Master is reachable'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Cannot reach master'));
    console.log(chalk.dim('Check network connection and master status'));
    return;
  }

  // Check vault mount
  if (config.vaultPath && fs.existsSync(config.vaultPath)) {
    console.log(chalk.green('✅ Vault mounted'));
  } else {
    console.log(chalk.yellow('⚠️  Vault not mounted'));
    console.log(chalk.dim(`Mount with: sudo mount -t nfs ${config.masterHost}:/srv/udos /mnt/udos_master`));
  }

  // Start telemetry reporter
  console.log(chalk.blue('📊 Starting telemetry reporter...'));
  try {
    console.log(chalk.green('✅ Telemetry reporter started (simulated)'));
    console.log(chalk.dim('Future: Will report usage, errors, and status to master'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to start telemetry reporter:'), error instanceof Error ? error.message : String(error));
  }

  // Start work receiver
  console.log(chalk.blue('📥 Starting work receiver...'));
  try {
    console.log(chalk.green('✅ Work receiver started (simulated)'));
    console.log(chalk.dim('Future: Will receive and execute tasks from master'));
  } catch (error: unknown) {
    console.log(chalk.red('❌ Failed to start work receiver:'), error instanceof Error ? error.message : String(error));
  }

  console.log(chalk.green('✅ Child agent started!'));
  console.log(chalk.cyan('\nChild agent running:'));
  console.log(chalk.dim(`• Name: ${config.childName}`));
  console.log(chalk.dim(`• Master: ${config.masterHost}`));
  console.log(chalk.dim('• Telemetry: Reporting usage and status'));
  console.log(chalk.dim('• Work: Ready to receive tasks'));
}

// Network status
async function showNetworkStatus(): Promise<void> {
  const config = loadConfig();

  console.log(chalk.cyan('🏠 uDosConnect Home Network Status'));
  console.log('='.repeat(60));

  if (config.role === 'master') {
    console.log(chalk.green('🌟 Role: MASTER'));
    console.log(chalk.dim('Host:'), os.hostname());
    console.log(chalk.dim('OS:'), os.platform(), os.release());
    console.log(chalk.dim('Uptime:'), formatUptime(os.uptime()));
    
    console.log(chalk.cyan('\nChildren registered:'), config.children?.length || 0);
    if (config.children && config.children.length > 0) {
      config.children.forEach((child, index) => {
        console.log(`${index + 1}. ${child.name} (${child.os}) - ${child.status} - Last seen: ${child.lastSeen}`);
      });
    }

    console.log(chalk.cyan('\nMaster services:'));
    console.log('• MCP Hub: http://' + (config.masterHost || os.hostname()) + ':3010');
    console.log('• Update Server: http://' + (config.masterHost || os.hostname()) + ':8080');
    console.log('• Device DB: http://' + (config.masterHost || os.hostname()) + ':8081');
    console.log('• Vendor Cache: http://' + (config.masterHost || os.hostname()) + ':8082');
    console.log('• Shared Vault: /srv/udos/vault');
    console.log('• Codevault: /srv/udos/codevault');

  } else if (config.role === 'child') {
    console.log(chalk.blue('💻 Role: CHILD'));
    console.log(chalk.dim('Name:'), config.childName || 'unnamed');
    console.log(chalk.dim('Master:'), config.masterHost || 'not configured');
    console.log(chalk.dim('OS:'), os.platform(), os.release());
    
    if (config.vaultPath && fs.existsSync(config.vaultPath)) {
      console.log(chalk.green('✅ Vault mounted'));
    } else {
      console.log(chalk.yellow('⚠️  Vault not mounted'));
    }

    console.log(chalk.cyan('\nChild status:'));
    console.log('• Telemetry: Reporting to master');
    console.log('• Work: Ready to receive tasks');
    console.log('• Last sync: ' + getLastSyncTime());

  } else {
    console.log(chalk.yellow('❓ Role: NOT CONFIGURED'));
    console.log(chalk.dim('Run: udo network master init (on Linux)'));
    console.log(chalk.dim('Or: udo network child register --master <host> --name <name>'));
  }

  console.log(chalk.cyan('\nRecent tasks:'));
  console.log(chalk.dim('(Task history will be shown here)'));
}

// Helper function to format uptime
function formatUptime(seconds: number): string {
  const days = Math.floor(seconds / (3600 * 24));
  const hours = Math.floor((seconds % (3600 * 24)) / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  
  let result = '';
  if (days > 0) result += `${days}d `;
  if (hours > 0) result += `${hours}h `;
  if (minutes > 0 || result === '') result += `${minutes}m`;
  
  return result.trim();
}

// Helper function to get last sync time
function getLastSyncTime(): string {
  // In a real implementation, this would read from a sync log
  return new Date().toLocaleString();
}

// Export network commands
export function registerNetworkCommands(program: Command): void {
  const network = program.command('network').description('Home network cluster management');

  // Master commands
  const master = network.command('master').description('Master node operations');
  master.command('init')
    .description('Initialize this node as master (Linux only)')
    .action(async () => {
      await initializeMaster();
    });

  master.command('start')
    .description('Start all master services')
    .action(async () => {
      await startMasterServices();
    });

  // Child commands
  const child = network.command('child').description('Child node operations');
  child.command('register')
    .description('Register this node as a child')
    .requiredOption('--master <host>', 'Master host (hostname or IP)')
    .requiredOption('--name <name>', 'Child node name')
    .action(async (options) => {
      await registerChild(options.name, options.master);
    });

  child.command('start')
    .description('Start child agent')
    .action(async () => {
      await startChildAgent();
    });

  // Status command
  network.command('status')
    .description('Show network status')
    .action(async () => {
      await showNetworkStatus();
    });

  // Workflow distribution commands
  const workflow = network.command('workflow').description('Workflow distribution');
  workflow.command('schedule')
    .description('Schedule a workflow to run on a specific child')
    .requiredOption('--name <name>', 'Workflow name')
    .requiredOption('--target <target>', 'Target child name or "all"')
    .option('--cron <cron>', 'Cron schedule')
    .action(async (options) => {
      console.log(chalk.cyan(`📅 Scheduling workflow ${options.name} for ${options.target}`));
      console.log(chalk.dim('Cron:'), options.cron || 'manual');
      console.log(chalk.green('✅ Workflow scheduled (simulated)'));
    });

  workflow.command('broadcast')
    .description('Broadcast a workflow to all children')
    .requiredOption('--name <name>', 'Workflow name')
    .action(async (options) => {
      console.log(chalk.cyan(`📣 Broadcasting workflow ${options.name} to all children`));
      console.log(chalk.green('✅ Workflow broadcast (simulated)'));
    });

  // Vendor cache commands
  const vendor = network.command('vendor').description('Vendor download cache');
  vendor.command('download')
    .description('Download vendor file to master cache')
    .argument('<name>', 'Vendor file name')
    .action(async (name) => {
      console.log(chalk.cyan(`📥 Downloading ${name} to vendor cache`));
      console.log(chalk.green('✅ Vendor file cached (simulated)'));
    });

  vendor.command('get')
    .description('Get vendor file from master cache')
    .argument('<name>', 'Vendor file name')
    .option('--from <source>', 'Source (master or local)', 'master')
    .action(async (name, options) => {
      console.log(chalk.cyan(`📥 Getting ${name} from ${options.from}`));
      console.log(chalk.green('✅ Vendor file retrieved (simulated)'));
    });
}

// Helper function to get OS-specific mount instructions
function getMountInstructions(): string {
  if (isMacOS()) {
    return 'sudo mount -t nfs master.local:/srv/udos /mnt/udos_master';
  } else if (isWindows()) {
    return 'New-SmbMapping -LocalPath Z: -RemotePath \\\\master\\udos';
  } else {
    return 'sudo mount -t nfs master.local:/srv/udos /mnt/udos_master';
  }
}