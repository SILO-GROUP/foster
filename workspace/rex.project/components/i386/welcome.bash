#!/usr/bin/env bash

read -d '' info << EOF
Dear User,

Thanks for trying to use SURRO Linux.

It's been a long road just getting to this point, and there is still so much more road to go.  

I hope you'll track the progress of this project, and even contribute.

We're going to turn those windmills into dragons.

Sincerely,
-C
EOF

whiptail \
--fullbuttons \
--backtitle "Foster - Variant B" \
--title "NOTICE" \
--ok-button "continue" \
--msgbox "$info" \
${mid_height} \
${max_width}

echo "hello $NAME"
