#!/bin/bash
set -e

/opt/ijhttp/ijhttp ${ENVIRONMENTS_FILE:+--env-file=$ENVIRONMENTS_FILE} ${SELECTED_ENVIRONMENT:+--env=$SELECTED_ENVIRONMENT} "${HTTP_FILE}"
