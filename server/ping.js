var http = require('http');

var options = {
  hostname: '127.0.0.1',
  port: 5000,
  path: '/add',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  }
};

var req = http.request(options, function(res) {
  res.setEncoding('utf8');
  res.on('data', function (chunk) {
    console.log('Response: ' + chunk);
  });
});

req.on('error', function(e) {
  console.log('problem with request: ' + e.message);
});

// Write data to request body
req.write(JSON.stringify({Ani: ['Lakshya', 'Adam'], Lakshya: ['Ani', 'Adam'], Adam: ['Lakshya']}));
req.end();