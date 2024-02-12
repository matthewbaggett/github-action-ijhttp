#!/bin/bash
set -e
# For each new line seperated entry in $VARIABLES, prefix it with --env-variables=
VARIABLES=$(echo "${VARIABLES}" | sed -e 's| |\n|g' -e '/^$/d' -e 's|^|--env-variables=|g')
# Same for SECRETS with --private-env-variables
SECRETS=$(echo "${SECRETS}" | sed -e 's| |\n|g' -e '/^$/d' -e 's|^|--private-env-variables=|g')

# shellcheck disable=SC2086,SC2312
/opt/ijhttp/ijhttp \
	${ENVIRONMENTS_FILE:+--env-file=${ENVIRONMENTS_FILE}} \
	${SELECTED_ENVIRONMENT:+--env=${SELECTED_ENVIRONMENT}} \
	${VARIABLES} \
	${SECRETS} \
	${HTTP_FILE} |
	tee /tmp/ijhttp_output

{
	echo "selected_environment=${SELECTED_ENVIRONMENT}"
	echo "report<<EOF"
	cat /tmp/ijhttp_output
	echo "EOF"
} >>"${GITHUB_OUTPUT}"
