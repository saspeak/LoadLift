{
comp_base_ref=$6
comp_base_alt=$7

if (comp_base_ref == "A" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""T""\t"".""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "A" && comp_base_alt == "T") {{printf $1"\t"$2"\t"$3"\t""T""\t""A""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "A" && comp_base_alt == "C") {{printf $1"\t"$2"\t"$3"\t""T""\t""G""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "A" && comp_base_alt == "G") {{printf $1"\t"$2"\t"$3"\t""T""\t""C""\t"}  for (i=b;i<=NF;i++) {printf  "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""A""\t"".""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == "A") {{printf $1"\t"$2"\t"$3"\t""A""\t""T""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == "C") {{printf $1"\t"$2"\t"$3"\t""A""\t""G""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == "G") {{printf $1"\t"$2"\t"$3"\t""A""\t""C""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""G""\t"".""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == "T") {{printf $1"\t"$2"\t"$3"\t""G""\t""A""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == "A") {{printf $1"\t"$2"\t"$3"\t""G""\t""T""\t"} for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == "G") {{printf $1"\t"$2"\t"$3"\t""G""\t""C""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""C""\t"".""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == "T") {{printf $1"\t"$2"\t"$3"\t""C""\t""A""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == "C") {{printf $1"\t"$2"\t"$3"\t""C""\t""G""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == "A") {{printf $1"\t"$2"\t"$3"\t""C""\t""T""\t"}  for (i=b;i<=NF;i++) {printf "%s%s", $i"\t", (i<NF ? OFS : ORS)}}
}
