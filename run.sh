

#!/bin/bash

API_DEV_KEY="0d90b5df18cbaca20c6cf93a36d429eb"
FILENAME="mine.lua"

if [ ! -f "$FILENAME" ]; then
  echo "File not found: $FILENAME"
  exit 1
fi

FILE_CONTENT=$(<"$FILENAME")

RESPONSE=$(curl -s -d "api_dev_key=${API_DEV_KEY}" \
                 -d "api_option=paste" \
                 -d "api_paste_code=${FILE_CONTENT}" \
                 -d "api_paste_format=lua" \
                 -d "api_paste_name=${FILENAME}" \
                 https://pastebin.com/api/api_post.php)

if [[ "$RESPONSE" == https://pastebin.com/* ]]; then
  echo "✅ Successfully uploaded: $RESPONSE"
else
  echo "❌ Failed to upload: $RESPONSE"
fi

