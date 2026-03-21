# Deployment Guide

This guide explains how to deploy the Lotus LMS Frontend to AWS S3 and CloudFront.

## Overview

The application is automatically deployed to AWS when code is pushed to the `main` branch. The deployment process:

1. Builds the Flutter web application
2. Uploads the build artifacts to an S3 bucket
3. Invalidates the CloudFront cache to ensure users see the latest version immediately

## Prerequisites

Before deployment can work, you need to configure the following GitHub repository secrets:

### Required Secrets

| Secret Name | Description | How to Find |
|------------|-------------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key with S3 and CloudFront permissions | AWS IAM Console |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key | AWS IAM Console |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID | AWS CloudFront Console |
| `API_BASE_URL` | Backend API URL | Your API Gateway URL |
| `RAZORPAY_KEY_ID` | Razorpay payment gateway key | Razorpay Dashboard |

## Setting Up CloudFront Distribution ID

### Step 1: Find Your CloudFront Distribution ID

1. Go to the [AWS CloudFront Console](https://console.aws.amazon.com/cloudfront/)
2. Find the distribution for your domain (e.g., `dodyqtcfhwoe.cloudfront.net`)
3. Click on the distribution to view details
4. Copy the **Distribution ID** (format: `E1234567890ABC`)

### Step 2: Add the Secret to GitHub

1. Go to your GitHub repository
2. Click on **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `CLOUDFRONT_DISTRIBUTION_ID`
5. Value: Paste the distribution ID you copied (e.g., `E1234567890ABC`)
6. Click **Add secret**

## Deployment Process

The deployment is fully automated via GitHub Actions (`.github/workflows/flutter-ci.yaml`):

### Workflow Steps

1. **Build Flutter App**: Compiles the Flutter web application
2. **Deploy to S3**: Uploads files to S3 bucket with proper cache headers
   - `index.html`: `no-cache` (always fetch latest)
   - Other assets: `max-age=86400` (24 hours cache)
3. **Invalidate CloudFront**: Clears CloudFront cache for path `/*`
4. **Wait for Completion**: Waits until invalidation is complete
5. **Output URLs**: Displays the live site URL

### Trigger Deployment

Deployment is triggered automatically when:
- Code is pushed to the `main` branch
- A pull request is merged to `main`

### Manual Deployment

You can also trigger a manual deployment:

1. Go to **Actions** tab in GitHub
2. Select **Flutter CI/CD** workflow
3. Click **Run workflow**
4. Select the `main` branch
5. Click **Run workflow**

## Deployment URLs

After deployment completes, your site will be available at:

- **Production URL**: `https://dodyqtcfhwoe.cloudfront.net`
- **S3 Bucket**: `s3://lms-frontend-dev-fceacbe3`

## Troubleshooting

### Cache Not Invalidating

If you still see old content after deployment:

1. Check the GitHub Actions logs to verify invalidation completed
2. Verify the `CLOUDFRONT_DISTRIBUTION_ID` secret is set correctly
3. Try a hard refresh in your browser (Ctrl+F5 or Cmd+Shift+R)
4. Clear your browser cache

### Deployment Fails

If deployment fails:

1. Check that all required secrets are configured
2. Verify AWS credentials have the necessary permissions:
   - `s3:PutObject` on the S3 bucket
   - `s3:DeleteObject` on the S3 bucket
   - `cloudfront:CreateInvalidation` on the distribution
   - `cloudfront:GetInvalidation` on the distribution
3. Review the GitHub Actions logs for specific error messages

### Permissions Required

The AWS IAM user needs these permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::lms-frontend-dev-fceacbe3",
        "arn:aws:s3:::lms-frontend-dev-fceacbe3/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation"
      ],
      "Resource": "arn:aws:cloudfront::*:distribution/*"
    }
  ]
}
```

## CloudFront Cache Invalidation

### What is Cache Invalidation?

CloudFront caches files at edge locations worldwide for faster delivery. When you deploy new code, CloudFront might still serve old cached files. Cache invalidation tells CloudFront to remove files from all edge locations and fetch fresh copies from S3.

### How It Works in Our Workflow

1. After S3 sync completes, the workflow creates an invalidation request
2. The invalidation applies to all files (`/*` path)
3. The workflow waits for invalidation to complete (usually 1-3 minutes)
4. Once complete, all users worldwide will see the latest version

### Cost Considerations

- First 1,000 invalidation paths per month are free
- Additional paths cost $0.005 per path
- Our workflow invalidates `/*` (counts as 1 path)
- Typical cost: $0 for normal deployment frequency

## Monitoring

### View Deployment Status

1. Go to **Actions** tab in GitHub
2. Click on the latest workflow run
3. Expand the **Deploy Web App to S3** job
4. View logs for each step

### CloudFront Invalidation Status

You can also check invalidation status in AWS:

1. Go to CloudFront Console
2. Select your distribution
3. Click on **Invalidations** tab
4. View recent invalidation requests and their status

## Best Practices

1. **Test Before Merging**: Always test changes in a pull request before merging to `main`
2. **Monitor Deployments**: Check GitHub Actions logs after each deployment
3. **Verify Live Site**: Visit the CloudFront URL after deployment to confirm changes are live
4. **Gradual Rollouts**: For major changes, consider blue-green deployments or feature flags

## Additional Resources

- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
