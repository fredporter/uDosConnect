/**
 * Main entry point for the uDos Webhook Helper Installer and Session Launcher
 */

import { Installer } from './installer';
import { SessionLauncher } from './session-launcher';

async function main() {
  try {
    const args = process.argv.slice(2);
    const command = args[0];
    let installer: Installer | undefined;
    let sessionLauncher: SessionLauncher | undefined;

    switch (command) {
      case 'install':
        installer = new Installer();
        await installer.install();
        break;
      case 'start':
        sessionLauncher = new SessionLauncher();
        await sessionLauncher.start();
        break;
      case 'stop':
        sessionLauncher = new SessionLauncher();
        await sessionLauncher.stop();
        break;
      case 'restart':
        sessionLauncher = new SessionLauncher();
        await sessionLauncher.restart();
        break;
      case 'health':
        installer = new Installer();
        await installer.healthCheck();
        break;
      case 'self-heal':
        installer = new Installer();
        await installer.selfHeal();
        break;
      case 'cleanup':
        installer = new Installer();
        await installer.cleanup();
        break;
      default:
        console.log('📋 uDos Webhook Helper Commands:');
        console.log('  install      Run the installer');
        console.log('  start        Start the session launcher');
        console.log('  stop         Stop the session launcher');
        console.log('  restart      Restart the session launcher');
        console.log('  health       Perform a health check');
        console.log('  self-heal    Perform self-healing');
        console.log('  cleanup      Clean up resources');
        break;
    }
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

main();