#!/bin/bash
echo "####################################################"
echo "### RELEASE SCRIPT V1.1.0"
echo "####################################################"

DEFAULTA=y

# fetch tags, to be sure we have all the require info
git fetch --tags

LAST_RELEASE=$(git describe --abbrev=0 --tags)

echo ""
echo "Last release : ${LAST_RELEASE}"

read -p "New release name ? " RELEASENAME

# collect the commits since the last tag
GIT_RELEASE_NOTES="$(git log ${LAST_RELEASE}..HEAD --pretty=format:"%h %s")"

cat <<EOF > ./temporary-release-notes.md
${RELEASENAME}

${GIT_RELEASE_NOTES}
EOF

echo ""
cat "./temporary-release-notes.md"

echo ""

read -p "OK ? [$DEFAULTA]/n: " A
A=${A:-$DEFAULTA}

if [ ${A} == "y" ]; then
    echo "Création de la release"
    gh release create -F "./temporary-release-notes.md" ${RELEASENAME}
    rm "./temporary-release-notes.md"
    ## script
else
    echo "Suppression du fichier temporaire"
    rm "./temporary-release-notes.md"
fi
