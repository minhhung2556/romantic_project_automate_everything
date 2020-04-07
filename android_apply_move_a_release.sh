OPTS=$1
echo 'OPTS='$OPTS

OUTPUT_CONFIG_FILE="build/config_apk.gradle"
ANDROID_PROJECT=
APK_NAME=
DESTINATION_DIR=

while getopts "n:a:d:" opt; do
case $opt in
a) APK_NAME="$OPTARG"
;;
d) DESTINATION_DIR="$OPTARG"
;;
n) ANDROID_PROJECT=$OPTARG
;;
*) { 
    echo "Available options are:"
    echo "-a = apk name"
    echo "-d = destination directory"
    echo "-n = android project directory"
    echo 'sample: sh android_apply_move_a_release.sh -a abc -d ../release -n /workspace/android_abc_project'
    exit 1
}
;;
esac
done

# functions

echo_params () {
    echo 'APK_NAME='$APK_NAME
    echo 'DESTINATION_DIR='$DESTINATION_DIR
    echo 'ANDROID_PROJECT='$ANDROID_PROJECT
}


get_file_name () {
    TMP_FILE_NAME="$(basename -- $1)"
}

create_config_file () {
    rm $OUTPUT_CONFIG_FILE
    cat > $OUTPUT_CONFIG_FILE <<EOF
android {
    android.applicationVariants.all { variant ->
        def _buildType = variant.name
        println("buildType: \$_buildType")
        if (_buildType == "release") {
            def _outputFileName = "../../../../../$DESTINATION_DIR/$APK_NAME.apk"
            println("outputFileName: \$_outputFileName")

            variant.outputs.each { output ->
                output.outputFileName = "\$_outputFileName"
            }    
        }
    }
}
EOF
}

copy_config_file () {
    cp $OUTPUT_CONFIG_FILE "$ANDROID_PROJECT/$TMP_FILE_NAME"
}

edit_app_build_gradle_file () {
    APP_BUILD_GRADLE_FILE=$ANDROID_PROJECT"/app/build.gradle"
    echo "apply from: \"../$TMP_FILE_NAME\"" >> $APP_BUILD_GRADLE_FILE
}

echo_params
create_config_file
get_file_name $OUTPUT_CONFIG_FILE
copy_config_file
edit_app_build_gradle_file
