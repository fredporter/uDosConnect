console.log('process.argv[0]:', process.argv[0]);
console.log('process.argv[1]:', process.argv[1]);
console.log('process.cwd():', process.cwd());
if (process.argv[1]) {
  const path = require('path');
  console.log('dirname(argv[1]):', path.dirname(process.argv[1]));
  console.log('includes core:', path.dirname(process.argv[1]).includes('core'));
  
  const scriptDir = path.dirname(process.argv[1]);
  const projectRoot = scriptDir.includes('core') 
    ? path.resolve(scriptDir, '..', '..') 
    : path.resolve(scriptDir, '..');
  console.log('calculated projectRoot:', projectRoot);
}