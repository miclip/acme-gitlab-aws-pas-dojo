
#!/bin/bash

set -eux

aws s3 --endpoint-url $S3_ENDPOINT --region $S3_REGION cp downloaded-product "s3://${S3_BUCKET_TERRAFORM}/artifacts/${PRODUCT_NAME}/downloaded-product/" --recursive
aws s3 --endpoint-url $S3_ENDPOINT --region $S3_REGION cp downloaded-stemcell "s3://${S3_BUCKET_TERRAFORM}/artifacts/${PRODUCT_NAME}/downloaded-stemcell/" --recursive
aws s3 --endpoint-url $S3_ENDPOINT --region $S3_REGION cp assign-stemcell-config "s3://${S3_BUCKET_TERRAFORM}/artifacts/${PRODUCT_NAME}/assign-stemcell-config/" --recursive