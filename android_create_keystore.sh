OPTS=$1
echo 'OPTS='$OPTS

DEFAULT_VALIDITY=36500

FILE_NAME=
ALIAS_NAME=
PASSWORD=
VALIDITY=
FULL_NAME=
ORGANIZATIONAL_UNIT=
ORGANIZATION=
CITY=
STATE_PROVINCE=
COUNTRY_CODE=

while getopts "f:a:p:v:n:u:o:i:s:c:" opt; do
case $opt in
f) FILE_NAME="$OPTARG"
;;
a) ALIAS_NAME="$OPTARG"
;;
p) PASSWORD="$OPTARG"
;;
v) VALIDITY=$OPTARG
;;
n) FULL_NAME=$OPTARG
;;
u) ORGANIZATIONAL_UNIT=$OPTARG
;;
o) ORGANIZATION=$OPTARG
;;
i) CITY=$OPTARG
;;
s) STATE_PROVINCE=$OPTARG
;;
c) COUNTRY_CODE=$OPTARG
;;
*) { 
    echo "Available options are:"
    echo "-f = output file name"
    echo "-a = alias name"
    echo "-p = password"
    echo "-v = validity duration (default is $DEFAULT_VALIDITY)"
    echo "-n = first and last name"
    echo "-u = organizational unit"
    echo "-o = organization"
    echo "-i = city"
    echo "-s = state or province"
    echo "-c = country code"
    exit 1
}
;;
esac
done

# functions

check_params () {
	if [ -z "$VALIDITY" ]
	then
	   VALIDITY=$DEFAULT_VALIDITY
	fi
}

echo_params () {
    echo 'FILE_NAME='$FILE_NAME
    echo 'ALIAS_NAME='$ALIAS_NAME
    echo 'PASSWORD='$PASSWORD
    echo 'VALIDITY='$VALIDITY
    echo 'FULL_NAME='$FULL_NAME
    echo 'ORGANIZATIONAL_UNIT='$ORGANIZATIONAL_UNIT
	echo 'ORGANIZATION='$ORGANIZATION
    echo 'CITY='$CITY
    echo 'STATE_PROVINCE='$STATE_PROVINCE
    echo 'COUNTRY_CODE='$COUNTRY_CODE
    echo 'sample: sh android_create_keystore.sh -f abc -a xyz -p 123456 -n luong\ do\ minh\ hung -u home -o home -i ho\ chi\ minh -s ho\ chi\ minh -c vn'
}

check_params
echo_params

rm $FILE_NAME".keystore"

keytool -genkey -v -keystore $FILE_NAME".keystore" -alias $ALIAS_NAME -storepass $PASSWORD -keypass $PASSWORD -keyalg RSA -validity $VALIDITY <<!
$FULL_NAME
$ORGANIZATIONAL_UNIT
$ORGANIZATION
$CITY
$STATE_PROVINCE
$COUNTRY_CODE
yes
!

keytool -importkeystore -srckeystore $FILE_NAME".keystore" -destkeystore $FILE_NAME".keystore" -deststoretype pkcs12 <<!
$PASSWORD
!

