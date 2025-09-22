#!/usr/bin/awk -f

BEGIN { FS=OFS="\t" }

!/^#/ {
    n = split($9, attrs, ";");
    
    $9 = "";

    for (i = 1; i <= n; i++) {
        split(attrs[i], kv, "=");
        key = kv[1];
        val = kv[2];

        # --- This is the core logic ---
        if (key == "NAME") {
            key = "Name";
        } else if (key != "ID" && key != "Parent") {
            key = tolower(key);
        }

        $9 = ($9 == "" ? "" : $9 ";") key "=" val;
    }
}

{ print }
