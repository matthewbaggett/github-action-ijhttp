#!/bin/bash

echo "Github Workspace is set to $GITHUB_WORKSPACE"
cd "$GITHUB_WORKSPACE"

echo -e "\nenvs:"
printenv | sort

echo -e "\nls -lah $GITHUB_WORKSPACE"
ls -lah "$GITHUB_WORKSPACE"

set -xe
# For each new line seperated entry in $VARIABLES, prefix it with --env-variables=
VARIABLES=$(echo "${VARIABLES}" | sed -e 's| |\n|g' -e '/^$/d' -e 's|^|--env-variables=|g')
# Same for SECRETS with --private-env-variables
SECRETS=$(echo "${SECRETS}" | sed -e 's| |\n|g' -e '/^$/d' -e 's|^|--private-env-variables=|g')
set +xe

# shellcheck disable=SC2086,SC2312
IJHTTP_OUTPUT=$(
	/opt/ijhttp/ijhttp \
		${ENVIRONMENTS_FILE:+--env-file=${ENVIRONMENTS_FILE}} \
		${SELECTED_ENVIRONMENT:+--env=${SELECTED_ENVIRONMENT}} \
		${VARIABLES} \
		${SECRETS} \
		${HTTP_FILE}
)
STATUS=$?

echo "$IJHTTP_OUTPUT"

{
	echo "selected_environment=${SELECTED_ENVIRONMENT}"
	echo "report<<EOF"
	echo "$IJHTTP_OUTPUT"
	echo "EOF"
} >>"${GITHUB_OUTPUT}"

exit $STATUS
