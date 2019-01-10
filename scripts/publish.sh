echo "---\n:rubygems_api_key: $RUBYGEMS_TOKEN" > ~/.gem/credentials

gem push ddsl-$(scripts/version.sh).gem