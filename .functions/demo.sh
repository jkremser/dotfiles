mvt() {
  printf "\e]0;${1}\a"
}

ipwhat() {
  curl -s http://ip-api.com/json/${1} | jq
}

ipmmdbinspect() { 
  mmdbinspect -db ./geoip.mmdb ${1}/32 | jq '.[].Records[]'
}
