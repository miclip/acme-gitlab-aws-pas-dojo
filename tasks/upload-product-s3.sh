
#!/bin/bash

set -eux

aws s3 --endpoint-url $S3_ENDPOINT --region $S3_REGION cp downloaded-files "s3://${S3_BUCKET_TERRAFORM}/artifacts/${PRODUCT_NAME}/downloaded-files/" --recursive
aws s3 --endpoint-url $S3_ENDPOINT --region $S3_REGION cp assign-stemcell-config "s3://${S3_BUCKET_TERRAFORM}/artifacts/${PRODUCT_NAME}/assign-stemcell-config/" --recursive