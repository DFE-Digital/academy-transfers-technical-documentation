# C4 Architecture Diagrams Source Code

This directory contains the diagrams-as-code file `workspace.dsl` used to define the workspace for [structurizr.com](https://structurizr.com/) for the C4 diagrams within the technical documentation site. 

The [structurizr.com](https://structurizr.com/) website provides a SaaS offering to generate diagrams from this code, but there are also plugins available for various IDEs such as VSCode. There is a Free Tier Cloud offering available which allows for one workspace to be created ([feature comparison](https://structurizr.com/products)).

This document details two usage options of the structurizr site - manual - where a workspace can be used manually to update the architecture diagrams, and atumated - where the repository build process is setup to automate the image generation using a single workspace in the SaaS offering.

## Generating the diagrams

### Automatic steps

Once the required secrets are setup within GitHub in order to access the Cloud Account for [structurizr](https://structurizr.com), then the GitHub actions CI/CD pipeline will automatically publish images on PRs to the master/main branch.

1. Sign up for a free Cloud account at [structurizr.com](https://structurizr.com/) (prefereably with a mailbox/service user, not a personal address).
2. Create an empty workspace. This will be used by the build process to automate image export.
3. Aquire the following configuration settings and put them in to your repository's secrets:

| Secret Key                | Secret Value  |
| ------------------------- | ------------- |
| STRUCTURIZR_USERNAME      | Website login username |
| STRUCTURIZR_PASSWORD      | Website login password |
| STRUCTURIZR_WORKSPACE_ID  | Workspace ID to upload the `<repo>/source-c4-diagrams/workspace.dsl` file to as part of build |
| STRUCTURIZR_API_KEY       | API key of workspace |
| STRUCTURIZR_API_SECRET    | API secret of workspace |

After creating the workspace, the workspace ID, API key and API secret settings can be accessed from the 'Settings' page of the workspace.

4. Run a build. Make a note of the generated file names (workspace ID will be redacted with asterix) and make any nessicary amends to the [main.yml](../.github/workflows/main.yml) file under the step 'Upload and publish C4 diagrams' to copy the files output to the correct place in the repository.

### Manual steps

1. Sign up for a Free Tier Cloud account at [structurizr.com](https://structurizr.com/).
2. Create a workspace and navigate to the 'DSL editor'.
3. Paste the code from the `.dsl` file in to the editor, verify it renders, Save the workspace.
4. Navigate back to the workspace overview, then to the 'Diagram viewer'.
5. Export the diagram to PNG (floppy disc icon).
6. Place within the correct folder in this repository for the C4 layer `/source/architecture/<layer>/images`, over-writing the existing file(s) there.

Any changes made in the Cloud service to the code need to be copied back in to the repository for version control.
