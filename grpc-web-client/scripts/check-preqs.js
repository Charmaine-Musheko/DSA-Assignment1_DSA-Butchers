#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const genDir = path.resolve(__dirname, '..', 'gen');
if (!fs.existsSync(genDir)) {
  console.error('\u001b[31mMissing generated stubs in "grpc-web-client/gen".\u001b[0m');
  console.error('Run protoc as documented in README.md before building the bundle.');
  process.exit(1);
}

const expected = ['patema_pb.js', 'patema_grpc_web_pb.js'];
const missing = expected.filter((file) => !fs.existsSync(path.join(genDir, file)));
if (missing.length > 0) {
  console.error(\u001b[31mMissing files in gen/: .\u001b[0m);
  console.error('Regenerate stubs with protoc.');
  process.exit(1);
}

console.log('Found generated stubs. Proceeding with build...');
