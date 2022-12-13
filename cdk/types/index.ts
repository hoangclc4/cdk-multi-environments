import {
  StackProps,
} from 'aws-cdk-lib';
export interface AppStackProps extends StackProps {
  readonly buildConfig: any;
}
export interface BuildConfig {
  readonly Environment: string;
  readonly Version: string;

  readonly Parameters: BuildParameters;
}

export interface BuildParameters {
  readonly APP_ENV: string;
  readonly REGION: string;
}

export interface S3ServiceProps {
  buildConfig: BuildConfig;
}
