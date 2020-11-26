#!/usr/bin/env bash

curl 'http://localhost:30090/nifi-api/processors/f6a719c6-0175-1000-0000-00003a21fa64/run-status' \
  -X 'PUT' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Content-Type: application/json' \
  -H 'Origin: http://localhost:30090' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:30090/nifi/?processGroupId=root&componentIds=d8753eba-0175-1000-ffff-ffffb777ac99%2Cd8791d27-0175-1000-0000-00007b0e6804%2Cd87a1756-0175-1000-0000-000038521c1d%2Cd87e35e3-0175-1000-ffff-ffffc883a25b%2Cd87e5f6d-0175-1000-0000-0000465667b9%2Cf6a719c6-0175-1000-0000-00003a21fa64%2Cf6a75091-0175-1000-0000-000069b2d15f%2Cf6ac35ff-0175-1000-0000-000014db0b4a%2Cf6ac65bf-0175-1000-ffff-ffffc2dec371' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: Idea-1e00aa=f726b8fa-080c-486f-8525-99f7a2437840' \
  --data-binary '{"revision":{"clientId":"017baa04-0176-1000-0574-aa87db9c6983","version":9},"state":"RUNNING","disconnectedNodeAcknowledged":false}' \
  --compressed



curl 'http://localhost:30090/nifi-api/processors/d87e35e3-0175-1000-ffff-ffffc883a25b/run-status' \
  -X 'PUT' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Content-Type: application/json' \
  -H 'Origin: http://localhost:30090' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:30090/nifi/?processGroupId=root&componentIds=d8753eba-0175-1000-ffff-ffffb777ac99%2Cd8791d27-0175-1000-0000-00007b0e6804%2Cd87a1756-0175-1000-0000-000038521c1d%2Cd87e35e3-0175-1000-ffff-ffffc883a25b%2Cd87e5f6d-0175-1000-0000-0000465667b9%2Cf6a719c6-0175-1000-0000-00003a21fa64%2Cf6a75091-0175-1000-0000-000069b2d15f%2Cf6ac35ff-0175-1000-0000-000014db0b4a%2Cf6ac65bf-0175-1000-ffff-ffffc2dec371' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: Idea-1e00aa=f726b8fa-080c-486f-8525-99f7a2437840' \
  --data-binary '{"revision":{"clientId":"017baa04-0176-1000-0574-aa87db9c6983","version":8},"state":"RUNNING","disconnectedNodeAcknowledged":false}' \
  --compressed

curl 'http://localhost:30090/nifi-api/processors/d8791d27-0175-1000-0000-00007b0e6804/run-status' \
  -X 'PUT' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Content-Type: application/json' \
  -H 'Origin: http://localhost:30090' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:30090/nifi/?processGroupId=root&componentIds=d8753eba-0175-1000-ffff-ffffb777ac99%2Cd8791d27-0175-1000-0000-00007b0e6804%2Cd87a1756-0175-1000-0000-000038521c1d%2Cd87e35e3-0175-1000-ffff-ffffc883a25b%2Cd87e5f6d-0175-1000-0000-0000465667b9%2Cf6a719c6-0175-1000-0000-00003a21fa64%2Cf6a75091-0175-1000-0000-000069b2d15f%2Cf6ac35ff-0175-1000-0000-000014db0b4a%2Cf6ac65bf-0175-1000-ffff-ffffc2dec371' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: Idea-1e00aa=f726b8fa-080c-486f-8525-99f7a2437840' \
  --data-binary '{"revision":{"clientId":"017baa04-0176-1000-0574-aa87db9c6983","version":8},"state":"RUNNING","disconnectedNodeAcknowledged":false}' \
  --compressed

curl 'http://localhost:30090/nifi-api/processors/d8753eba-0175-1000-ffff-ffffb777ac99/run-status' \
  -X 'PUT' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Content-Type: application/json' \
  -H 'Origin: http://localhost:30090' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:30090/nifi/?processGroupId=root&componentIds=d8753eba-0175-1000-ffff-ffffb777ac99%2Cd8791d27-0175-1000-0000-00007b0e6804%2Cd87a1756-0175-1000-0000-000038521c1d%2Cd87e35e3-0175-1000-ffff-ffffc883a25b%2Cd87e5f6d-0175-1000-0000-0000465667b9%2Cf6a719c6-0175-1000-0000-00003a21fa64%2Cf6a75091-0175-1000-0000-000069b2d15f%2Cf6ac35ff-0175-1000-0000-000014db0b4a%2Cf6ac65bf-0175-1000-ffff-ffffc2dec371' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: Idea-1e00aa=f726b8fa-080c-486f-8525-99f7a2437840' \
  --data-binary '{"revision":{"clientId":"017baa04-0176-1000-0574-aa87db9c6983","version":8},"state":"RUNNING","disconnectedNodeAcknowledged":false}' \
  --compressed

curl 'http://localhost:30090/nifi-api/processors/f6ac35ff-0175-1000-0000-000014db0b4a/run-status' \
  -X 'PUT' \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36' \
  -H 'Content-Type: application/json' \
  -H 'Origin: http://localhost:30090' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: http://localhost:30090/nifi/?processGroupId=root&componentIds=d8753eba-0175-1000-ffff-ffffb777ac99%2Cd8791d27-0175-1000-0000-00007b0e6804%2Cd87a1756-0175-1000-0000-000038521c1d%2Cd87e35e3-0175-1000-ffff-ffffc883a25b%2Cd87e5f6d-0175-1000-0000-0000465667b9%2Cf6a719c6-0175-1000-0000-00003a21fa64%2Cf6a75091-0175-1000-0000-000069b2d15f%2Cf6ac35ff-0175-1000-0000-000014db0b4a%2Cf6ac65bf-0175-1000-ffff-ffffc2dec371' \
  -H 'Accept-Language: en-US,en;q=0.9' \
  -H 'Cookie: Idea-1e00aa=f726b8fa-080c-486f-8525-99f7a2437840' \
  --data-binary '{"revision":{"clientId":"017baa04-0176-1000-0574-aa87db9c6983","version":8},"state":"RUNNING","disconnectedNodeAcknowledged":false}' \
  --compressed