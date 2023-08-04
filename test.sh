#npx tsc
# npm config set proxy http://127.0.0.1:8080/
# npm config set https-proxy http://127.0.0.1:8080/

npm config rm proxy 
npm config rm https-proxy 


node --trace-warnings --trace-exit app.js '{"poolName": "iExec Newsletter", "authorizedContributors": "0xaEe862A38beE4Cee76367880696a0c2E2830f259,0x92077bB7DC20854E54D5a7B2029fBA1CBC030464", "autorizedApps":"0x207a2dba98da5d133b39b7c5a57fae035c4aaeba",  "authorizedUsers": "0xaEe862A38beE4Cee76367880696a0c2E2830f259,0x92077bB7DC20854E54D5a7B2029fBA1CBC030464"}'
