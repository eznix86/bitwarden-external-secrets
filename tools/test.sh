#!/bin/bash

helm lint charts/bitwarden-external-secrets/
helm template charts/bitwarden-external-secrets/
helm package charts/bitwarden-external-secrets/