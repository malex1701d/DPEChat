# Changes

This document tracks important changes in the local branch of the base project.

## 2024-01-05

- Changed hard coded title in the [index.html](client\index.html) from `LibreChat` to `DPE Chat`
- Removed the automatic fetching of models from OpenAI [here](api/server/services/Config/loadDefaultModels.js) as this causes a fatal error when only Azure models are in use and no OpenAI key is provided. Will likely have to be reverted for the app to function fully with OpenAI endpoints
- To isolate the changes created an `AzureOnly` branch. Will likely later be turned into a fork.