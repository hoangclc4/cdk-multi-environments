#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { CdkStack } from '../lib/cdk-stack';
import { AppStackProps } from '../types';
import { Utils } from '../utils';

const app = new cdk.App();
const env = app.node.tryGetContext('config');
if (!env)
  throw new Error(
    'Missing environment context. Pass in as `dev|stag|prod` in last command line argument.'
  );
const buildConfig: any = app.node.tryGetContext(env);

const stackName = `${Utils.getEnv('STACK_NAME')}-${env}`;
const stackAccount = Utils.getEnv('STACK_ACCOUNT');
const stackRegion = Utils.getEnv('STACK_REGION');

const stackProps: AppStackProps = {
  env: { region: stackRegion, account: stackAccount },
  buildConfig,
};

cdk.Tags.of(app).add('App', stackName);
cdk.Tags.of(app).add('Environment', buildConfig.Environment);
cdk.Tags.of(app).add('Version', buildConfig.Version);

new CdkStack(app, stackName, stackProps);
