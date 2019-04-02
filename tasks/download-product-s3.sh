
#!/bin/bash

set -eux

aws s3 --endpoint-url $S3_ENDPOINT --region $S3_REGION cp "s3://${S3_BUCKET_TERRAFORM}/artifacts/${PRODUCT_NAME}" $PRODUCT_NAME --recursive