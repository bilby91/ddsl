COMPILED_GEM_PATH=ddsl-$(scripts/version.sh).gem

if [ ! -f $COMPILED_GEM_PATH ]; then
  echo "Compiled gem not found at $COMPILED_GEM_PATH"
  exit -1
fi

# Copy RUBYGEMS_TOKEN to the credentials file
echo "---\n:rubygems_api_key: $RUBYGEMS_TOKEN" > ~/.gem/credentials

# Fix permissions
chmod 0600 ~/.gem/credentials

# Push current gem version
gem push $COMPILED_GEM_PATH