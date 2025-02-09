Workflow options

Change these options in the workflow .yml file to meet your GitHub project needs.
Inputs 	Description 	Values
on 	When the automation is ran 	issues pull_request issue_comment pull_request_target pull_request_review
types 	The types of activity that will trigger a workflow run. 	opened, assigned, edited: See GitHub docs for more
project 	The name of the project 	Backlog
column 	The column to create or move the card to 	Triage
repo-token 	The personal access token 	${{ secrets.GITHUB_TOKEN }}
action 	This determines the type of the action to be performed on the card, Default: update 	update, delete, archive, add
Personal access token

Most of the time GITHUB_TOKEN will work as your repo-token. This requires no set up. If you have a public project board and public repository this is the option for you.

Repository project, private repository or organisation projects

You will need a personal access token to send events from your issues and pull requests.

    Create a personal access token
        Public repository and repository project
        Private repository or private project
        Organisation project board or organisation repository

    Add a secret GHPROJECT_TOKEN with the personal access token.

    Update the repo-token in the workflow .yml to reference your new token name:

repo-token: ${{ secrets.GHPROJECT_TOKEN }}

Troubleshooting

GraphqlError: Resource not accessible by integration or Secrets are not currently available to forks.

This error happens on repository projects and forked repositories because GITHUB_TOKEN only has read permissions. Create a personal access token following the instructions above.

Parameter token or opts.auth is required

This error happens when using a personal access token to run the workflow on PRs from forked repositories. This is because GitHub secrets are not populated for workflows triggered by forks. Use pull_request_target as the webhook event instead to enable access to secrets.

SAML enforcement

With certain organisations there may be SAML enforcement. This means you will need to Enable SSO when you create the personal access token.

GraphqlError: Resource protected by organization SAML enforcement. You must grant your personal token access to this organization

Can't read repository null

Make sure your permissions for your personal access token are correctly configured. Follow the above guide on permissions.

Private repositories

You may need to enable policy settings to allow running workflows from forks. Please refer to GitHub's documentation to learn about enabling these settings at enterprise, organization, or repository level.
