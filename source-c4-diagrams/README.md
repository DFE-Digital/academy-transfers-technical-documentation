# C4 Diagrams Source Code (DSL)

This directory contains the diagrams-as-code files used to create the C4 diagrams within the technical documentation site. The [structurizr.com](https://structurizr.com/) website provides a SaaS offering to generate diagrams from this code, but there are also plugins available for various IDEs such as VSCode.

## Generating the diagrams

### Automatic steps

These steps are performed as part of the GitHub Actions CI/CD pipelines, provided that the required secrets are setup within GitHub in order to access the Cloud Account for [structurizr](https://structurizr.com).

| Secret Key                | Secret Value  |
| ------------------------- | ------------- |
| STRUCTURIZR_USERNAME      | Website login username |
| STRUCTURIZR_PASSWORD      | Website login password |
| STRUCTURIZR_WORKSPACE_ID  | Workspace ID to upload the `<repo>/source-c4-diagrams/workspace.dsl` file to as part of build |
| STRUCTURIZR_API_KEY       | API key of workspace |
| STRUCTURIZR_API_SECRET    | API secret of workspace |

We firstly need to register for the free Cloud account (prefereably with a mailbox, not individual address) and create the target workspace used by the build proces to automate image export.

After creating the workspace, the workspace ID, API key and API secret settings can be accessed from the 'Settings' page of the workspace.

### Manual steps

1. Sign up for a Free Tier Cloud account at [structurizr.com](https://structurizr.com/).
2. Create a workspace and navigate to the 'DSL editor'.
3. Paste the code from the `.dsl` file in to the editor, verify it renders, Save the workspace.
4. Navigate back to the workspace overview, then to the 'Diagram viewer'.
5. Export the diagram to PNG (floppy disc icon).
6. Place within the correct folder in this repository for the C4 layer `/source/architecture/<layer>/images`, over-writing the existing file(s) there.
