console.log('process.argv[1]:', process.argv[1]);
const path = require('path');
if (process.argv[1]) {
  console.log('dirname:', path.dirname(process.argv[1]));
  console.log('basename:', path.basename(process.argv[1]));
  
  // Check if it's the compiled version
  const isCompiled = process.argv[1].includes('dist');
  console.log('isCompiled:', isCompiled);
  
  if (isCompiled) {
    // For compiled version: /Users/.../core/dist/cli.js
    // We need to go up 2 levels to get to project root
    const projectRoot = path.resolve(path.dirname(process.argv[1]), '..', '..');
    console.log('projectRoot (compiled):', projectRoot);
  } else {
    // For source version: /Users/.../core/bin/udo.mjs  
    // We need to go up 1 level to get to project root
    const projectRoot = path.resolve(path.dirname(process.argv[1]), '..');
    console.log('projectRoot (source):', projectRoot);
  }
}