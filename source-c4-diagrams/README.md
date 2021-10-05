# C4 Diagrams Source Code (DSL)

This directory contains the diagrams-as-code files used to create the C4 diagrams within the technical documentation site. The [structurizr.com](https://structurizr.com/) website provides a SaaS offering to generate diagrams from this code, but there are also plugins available for various IDEs such as VSCode.

## Generating the diagrams

### Manual steps

1. Sign up for a Free Tier Cloud account at [structurizr.com](https://structurizr.com/).
2. Create a workspace and navigate to the 'DSL editor'.
3. Paste the code from the `.dsl` file in to the editor, verify it renders, Save the workspace.
4. Navigate back to the workspace overview, then to the 'Diagram viewer'.
5. Export the diagram to PNG (floppy disc icon).
6. Place within the correct folder in this repository for the C4 layer `/source/architecture/<layer>/images`, over-writing the existing file(s) there.