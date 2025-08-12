import os
from ibm_watsonx_ai import APIClient
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

api_key = os.getenv("IBM_CLOUD_API_KEY")
project_id = os.getenv("WATSONX_PROJECT_ID")
endpoint = os.getenv("WATSONX_ENDPOINT", "https://us-south.ml.cloud.ibm.com")

if not api_key or not project_id:
    raise SystemExit("Set IBM_CLOUD_API_KEY and WATSONX_PROJECT_ID env vars (see .env.example)")

creds = {"url": endpoint, "apikey": api_key}
client = APIClient(credentials=creds, project_id=project_id)

# cheap health/ping: list models or projects (accounts vary)
try:
    models = client.foundation_models.list()
    print(f"OK: fetched {len(models.get('resources', []))} models from {endpoint}")
except Exception as e:
    print("Connected to watsonx, but listing models failed—check permissions:")
    print(repr(e))
