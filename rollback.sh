#!/bin/bash
PROJECT_ID=$(gcloud projects list --filter="name:'My First Project'" --format='value(PROJECT_ID)')

terraform destroy -var="project_id=${PROJECT_ID}"