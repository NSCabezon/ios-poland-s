set -x

echo "Firebase Google Service Info script"

GOOGLE_SERVICES_PATH=$SRCROOT/Santander/Configuration/GoogleServices
GOOGLE_SERVICE_FILENAME=GoogleService-Info.plist
BUILD_APP_DIR=$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.app

DEV=GoogleService-Info-development.plist
INTERN=GoogleService-Info-intern.plist
PRE=GoogleService-Info-pre.plist
PROD=GoogleService-Info-production.plist
UAT=GoogleService-Info-uat.plist
REGRESSION=GoogleService-Info-regression.plist
PREPROD=GoogleService-Info-preprod.plist

GOOGLE_SERVICE_ORIGIN=$DEV
if [[ "$CONFIGURATION" == "Dev-Debug" ]] || [[ "$CONFIGURATION" == "Dev-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$DEV
elif [[ "$CONFIGURATION" == "Intern-Debug" ]] || [[ "$CONFIGURATION" == "Intern-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$INTERN
elif [[ "$CONFIGURATION" == "Pre-Debug" ]] || [[ "$CONFIGURATION" == "Pre-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$PRE
elif [[ "$CONFIGURATION" == "Pro-Debug" ]] || [[ "$CONFIGURATION" == "Pro-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$PROD
elif [[ "$CONFIGURATION" == "Uat-Debug" ]] || [[ "$CONFIGURATION" == "Uat-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$UAT
elif [[ "$CONFIGURATION" == "Preprod-Debug" ]] || [[ "$CONFIGURATION" == "Preprod-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$PREPROD
elif [[ "$CONFIGURATION" == "Regression-Debug" ]] || [[ "$CONFIGURATION" == "Regression-Release" ]]; then
    GOOGLE_SERVICE_ORIGIN=$REGRESSION
fi

GOOGLE_SERVICE_ORIGIN_PATH=$GOOGLE_SERVICES_PATH/$GOOGLE_SERVICE_ORIGIN
GOOGLE_SERVICE_DESTINY_PATH=$BUILD_APP_DIR/$GOOGLE_SERVICE_FILENAME
cp $GOOGLE_SERVICE_ORIGIN_PATH $GOOGLE_SERVICE_DESTINY_PATH
