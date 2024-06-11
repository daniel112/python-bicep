import azure.functions as func
import logging
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
import os
import subprocess

app = func.FunctionApp()

@app.route(route="HttpExample", methods=["POST"])
def HttpExample(req: func.HttpRequest) -> func.HttpResponse:
    '''
        This function is triggered by an HTTP request. It authenticates with the Azure SDK using DefaultAzureCredential
        then attempts to deploy the bundled bicep file to the Azure subscription tied to the DefaultAzureCredential.
    '''
    logging.info('---Authenticating with Default Creds---')
    # account_url = "https://dyobicepstorage2.blob.core.windows.net"
    _ = DefaultAzureCredential()
    logging.info('---Authenticated---')
    run_az_cli_command(["az", "account", "list"])
    # Create the BlobServiceClient object
    # blob_service_client = BlobServiceClient(account_url, credential=credentials)
    current_dir = os.path.dirname(__file__)
    file_path = os.path.join(current_dir, 'bicep', 'cosmos.bicep')
    logging.info('---BICEP FILE PATH---')
    logging.info(file_path)

    # Check if the file exists
    if os.path.exists(file_path):
        logging.info('File exists, do the thing')
        # az deployment group create --resource-group DefaultResourceGroup-WUS --template-file cosmos.bicep
        command = ["az", "deployment", "group", "create", 
                   "--resource-group", "DefaultResourceGroup-WUS", 
                   "--template-file", file_path]
        # run_az_cli_command(command)

    else:
        logging.info('File DNE')

    return func.HttpResponse(
            "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
            status_code=200
    )

def run_az_cli_command(command):
    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        print("Output:\n", result.stdout)
        if result.stderr:
            print("Errors:\n", result.stderr)
    except subprocess.CalledProcessError as e:
        print("An error occurred while running the Azure CLI command")
        print("Error message:\n", e.stderr)