SCRIPT_TEMP_FILE="$(mktemp -t run-swift)"
trap "rm $SCRIPT_TEMP_FILE" SIGHUP SIGINT SIGTERM exit

files=()
xcrun_arguments=()
script_arguments=()

script_path=$1
script_contents=$(cat $script_path)
dirname=$(dirname $script_path)

for arg in "${@:2}"; do
  script_arguments+=($arg)
done

preprocess_pattern="^#!(arg|import) (.*)"

should_preprocess() {
  while read -r line; do
    if [[ $line =~ $preprocess_pattern ]]; then
      return 1
    fi
  done <<< "$1"

  return 0
}

new_files=()
preprocess() {
  new_files=()

  while read -r line; do
    if [[ $line =~ $preprocess_pattern ]]; then
      case ${BASH_REMATCH[1]} in
        "arg" )
          xcrun_arguments+=(${BASH_REMATCH[2]})
        ;;
        "import" )
          file="$dirname/${BASH_REMATCH[2]}"
          if ! [[ ${files[@]} =~ "$file" ]]; then
            new_files+=($file)
          fi
        ;;
      esac
    fi
  done <<< "$1"
}

until should_preprocess "$script_contents"; do 
  preprocess "$script_contents"
  if [ ${#new_files[@]} -eq 0 ]; then
    break
  fi

  files=("${new_files[@]}" "${files[@]}")

  for f in ${files[@]}; do cat "$f"; printf "\n"; done > $SCRIPT_TEMP_FILE
  script_contents=$(cat $SCRIPT_TEMP_FILE)
done

files+=($script_path)

for f in ${files[@]}; do cat "$f"; printf "\n"; done > $SCRIPT_TEMP_FILE
sed -i '' '/^#/d' $SCRIPT_TEMP_FILE

eval "xcrun swift ${xcrun_arguments[@]} $SCRIPT_TEMP_FILE ${script_arguments[@]}"

exit $?
