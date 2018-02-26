#!/usr/bin/env sh

set -e

### begin login
loginCmd='az login -u "$loginId" -p "$loginSecret"'

# handle opts
if [ "$loginTenantId" != " " ]; then
    loginCmd=$(printf "%s --tenant %s" "$loginCmd" "$loginTenantId")
fi

case "$loginType" in
    "user")
        echo "logging in as user"
        ;;
    "sp")
        echo "logging in as service principal"
        loginCmd=$(printf "%s --service-principal" "$loginCmd")
        ;;
esac
eval "$loginCmd" >/dev/null

echo 'setting default subscription'
az account set --subscription "$subscriptionId"
### end login

echo 'getting secret'
az keyvault secret show \
    --name "$secretName" \
    --vault-name "$vaultName" \
    > /secret