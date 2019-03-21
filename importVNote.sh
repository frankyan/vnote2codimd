#!/usr/bin/env bash
PROGNAME=$0

usage() {
    cat << EOF >&2
    Usage: $PROGNAME [-s <server_url>] [-u <user@mail>] [-c <container>] [-m <md_file>] 

    Dependency: curl, docker

    This script can import a VNote note to self-hosted CodiMD server. It's better to use the VNote exported Markdown
    file folder.

    -s : CodiMD server URL. Such as "http://www.example.org:3000".
    -u : User email address (registered account) for login CodiMD.
    -c : Container id or name.
    -m : markdown file.
    -h : Show usage help
EOF
    exit 1
}

while getopts :s:u:c:m:h opt; do
    case $opt in
        s) serverURL=${OPTARG};;
        u) userMail=${OPTARG};;
        c) container=${OPTARG};;
        m) mdFile=${OPTARG};;
        h) usage;;
    esac
done

if ! (curl --output /dev/null --silent --head --fail "$serverURL"); then
    echo "This Server URL Not Exist: $serverURL" && usage
fi

[ ! -f "$mdFile" ] && echo "Error!! Markdown file not exist: "$mdFile && usage

echo -n "Enter your password to account $userMail [ENTER]: "
read -s password

DIR=$(dirname "${mdFile}")

CODIMD_COOKIES_FILE="$DIR/.tmpkey_"${RANDOM}

curl -c $CODIMD_COOKIES_FILE \
    -XPOST \
    -d "email=${userMail}&password=${password}" \
    $serverURL/login &>/dev/null

STATUS=$(curl -b $CODIMD_COOKIES_FILE $serverURL/me 2>/dev/null)

if [[ $STATUS =~ "\"status\":\"ok\"" ]]; then
        echo "Logged in $serverURL as $userMail successfully."
    else
        echo "Failed to login at $serverURL."
        rm $CODIMD_COOKIES_FILE
        exit 1
fi 

tmp_mdFile="$DIR/tmpmd_$RANDOM.md"

sed -e "s|](_v_|](/uploads/_v_|g" $mdFile > $tmp_mdFile

curl -q -b $CODIMD_COOKIES_FILE -XPOST -H 'Content-Type: text/markdown' \
    --data-binary "@$tmp_mdFile" "$serverURL/new" 2>/dev/null | perl -pe 's/Found. Redirecting to \/(.+?)$/$1\n/gs'

docker cp $DIR/_v_attachments/ $container:/codimd/public/uploads
docker cp $DIR/_v_images/ $container:/codimd/public/uploads

rm $tmp_mdFile
rm $CODIMD_COOKIES_FILE