# Lotus LMS Platform Frontend

## Project Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/blackgardentechin/lotus-lms-platform-frontend.git
   ```
2. Navigate to the project directory:
   ```bash
   cd lotus-lms-platform-frontend
   ```
3. Install the dependencies:
   ```bash
   npm install
   ```
4. Run the development server:
   ```bash
   npm start
   ```

## S3 Deployment Guide

1. Create an S3 bucket in AWS.
2. Configure the bucket policy to allow public access (if necessary).
3. Build the project for production:
   ```bash
   npm run build
   ```
4. Upload the contents of the `build` folder to your S3 bucket.
5. Set the appropriate permissions for your files in S3.
6. Enable static website hosting in your S3 bucket settings.

## Cognito Configuration Documentation

1. Go to the Amazon Cognito console.
2. Create a new User Pool or select an existing one.
3. Configure the app client settings, ensuring that the required attributes are enabled.
4. Set up domain name under the "App integration" section.
5. Update your application’s environment variables with the User Pool ID and App Client ID.
6. Test the authentication flow to ensure that it works correctly.

For more detailed guidance, refer to the [AWS documentation](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html).