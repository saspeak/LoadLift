{
comp_base_ref=$6
comp_base_alt=$7

if (comp_base_ref == "A" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""T""\t""."}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "A" && comp_base_alt == "T") {{printf $1"\t"$2"\t"$3"\t""T""\t""A"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "A" && comp_base_alt == "C") {{printf $1"\t"$2"\t"$3"\t""T""\t""G"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "A" && comp_base_alt == "G") {{printf $1"\t"$2"\t"$3"\t""T""\t""C"}  for (i=b;i<=NF;i++) {printf  "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""A""\t""."}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == "A") {{printf $1"\t"$2"\t"$3"\t""A""\t""T"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == "C") {{printf $1"\t"$2"\t"$3"\t""A""\t""G"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "T" && comp_base_alt == "G") {{printf $1"\t"$2"\t"$3"\t""A""\t""C"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""G""\t""."}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == "T") {{printf $1"\t"$2"\t"$3"\t""G""\t""A"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == "A") {{printf $1"\t"$2"\t"$3"\t""G""\t""T"} for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "C" && comp_base_alt == "G") {{printf $1"\t"$2"\t"$3"\t""G""\t""C"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == ".") {{printf $1"\t"$2"\t"$3"\t""C""\t""."}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == "T") {{printf $1"\t"$2"\t"$3"\t""C""\t""A"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == "C") {{printf $1"\t"$2"\t"$3"\t""C""\t""G"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}};
if (comp_base_ref == "G" && comp_base_alt == "A") {{printf $1"\t"$2"\t"$3"\t""C""\t""T"}  for (i=b;i<=NF;i++) {printf "%s%s", "\t"$i, (i<NF ? OFS : ORS)}}
}
