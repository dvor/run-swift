TEMP_FILE="/tmp/$(uuidgen).swift"

cleanup() {
    rm $TEMP_FILE
}

trap "cleanup; exit" SIGHUP SIGINT SIGTERM

stage_files="files"
stage_source="source"
stage_xcrun_args="xcrun_args"
stage_script_args="script_args"

current=$stage_files
files=()
xcrun_arguments=()
script_arguments=()

for arg in "$@"; do
    if [ $arg == "END" ]; then
        current=$stage_source
        continue
    fi

    if [ $arg == "ARGS" ]; then
        current=$stage_xcrun_args
        continue
    fi

    if [ $current == $stage_files ]; then
        files+=($arg)
    elif [ $current == $stage_source ]; then
        files=("${files[@]} $arg")
        current=$stage_script_args
    elif [ $current == $stage_xcrun_args ]; then
        xcrun_arguments+=($arg)
    elif [ $current == $stage_script_args ]; then
        script_arguments+=($arg)
    fi
done

for f in $files; do cat "$f"; echo "\n"; done > $TEMP_FILE
sed -i '' '/^#/d' $TEMP_FILE


eval "xcrun swift ${xcrun_arguments[@]} $TEMP_FILE ${script_arguments[@]}"
result=$?

cleanup

exit $result
