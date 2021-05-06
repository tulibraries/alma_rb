mkdir ~/.gem
echo -e "---\r\n:rubygems_api_key: $ALMA_RUBYGEMS" > ~/.gem/credentials
chmod 0600 /home/circleci/.gem/credentials
