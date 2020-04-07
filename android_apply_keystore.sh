OPTS=$1
echo 'OPTS='$OPTS

OUTPUT_CONFIG_FILE="build/config_signing.gradle"
KEYSTORE_FILE=
ALIAS_NAME=
PASSWORD=
ANDROID_PROJECT=

while getopts "f:a:p:n:" opt; do
case $opt in
f) KEYSTORE_FILE="$OPTARG"
;;
a) ALIAS_NAME="$OPTARG"
;;
p) PASSWORD="$OPTARG"
;;
n) ANDROID_PROJECT=$OPTARG
;;
*) { 
    echo "Available options are:"
    echo "-f = keystore file path"
    echo "-a = alias name"
    echo "-p = password"
    echo "-n = android project directory"
    echo 'sample: sh android_apply_keystore.sh -f abc -a xyz -p 123456 -n /workspace/android_abc_project'
    exit 1
}
;;
esac
done

# functions

echo_params () {
    echo 'KEYSTORE_FILE='$KEYSTORE_FILE
    echo 'ALIAS_NAME='$ALIAS_NAME
    echo 'PASSWORD='$PASSWORD
    echo 'ANDROID_PROJECT='$ANDROID_PROJECT
}

copy_keystore_file () {
    cp $KEYSTORE_FILE "$ANDROID_PROJECT/$TMP_FILE_NAME"
}

get_file_name () {
    TMP_FILE_NAME="$(basename -- $1)"
}

create_config_file () {
    rm $OUTPUT_CONFIG_FILE
    cat > $OUTPUT_CONFIG_FILE <<EOF
android {
    signingConfigs {
        app_release {
            storeFile file("../$TMP_FILE_NAME")
            keyAlias "$ALIAS_NAME"
            keyPassword "$PASSWORD"
            storePassword "$PASSWORD"
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.app_release
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
get_file_name $KEYSTORE_FILE
mkdir -p $ANDROID_PROJECT
copy_keystore_file
create_config_file
get_file_name $OUTPUT_CONFIG_FILE
copy_config_file
edit_app_build_gradle_file
