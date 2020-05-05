# azureDevOps.CostSavings

These are the companion scripts to a blog post I wrote with strategies to examine your spend in Azure DevOps, covering license usage and pipeline efficiency. For a complete rundown of these scripts see [Cost Savings In Azure DevOps](https://www.sentryone.com/blog/cost-savings-in-azuredevops).

## To get up and running

- The Project Collection Build Service will need View Analytics rights for the project the pipeline is running in.
  
- If you would like to push a notification to a Slack channel, you will need a token to do so. That token needs to be set as a secret variable, `SlackToken`, in your pipeline. If you want to skip the Slack message, that's not a problem. Simply comment out or remove those tasks from the pipeline file; the markdown files will still be available to download as artifacts.

