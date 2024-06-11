# Demo of Azure Functions with Python

Python Azure Functions that deploys a bicep resource on trigger.

- Auth is using Managed Identity with role that can deploy bicep files

**Things to consider after POC:**

- Deploying bicep file(s) takes a while, so the function might timeout. (this demo uses cosmos bicep file only. it takes about 1 minute)
- Consider using a queueing method because you don't want to accidentally call this multiple times

## Requirements

- [Azure functions core tools](https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-python?tabs=windows%2Cbash%2Cazure-cli%2Cbrowser#install-the-azure-functions-core-tools)
- Python 3.9+ (obviously)

## Run

- Use venv as best practice

```
source .venv/bin/activate
```

- Install requirements

```bash
pip install -r requirements.txt
```

- Run the function

```
func start
```

## Deploy

```
func azure functionapp publish func-bicep-python-dyo2
```

Bicep:

1. Navigate to the `/bicep` folder
2. Run:
   `az deployment group create --resource-group DefaultResourceGroup-WUS --template-file cosmos.bicep`

## reference

- https://learn.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-python?tabs=macos%2Cbash%2Cazure-cli%2Cbrowser
