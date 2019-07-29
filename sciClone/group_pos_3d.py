# author: Yifei.wan
# Group positions by the cluster

import sys

input_cluster = sys.argv[1]
input_anno1 = sys.argv[2]
input_anno2 = sys.argv[3]
input_anno3 = sys.argv[4]
output_file = sys.argv[5]

with open(input_cluster, "r") as raw, open(input_anno1, "r") as anno1, open(input_anno2, "r") as anno2, open(input_anno3, "r") as anno3, open(output_file, "w+") as output:
    clus = raw.readlines()
    genes1 = anno1.readlines()
    genes2 = anno2.readlines()
    genes3 = anno3.readlines()
    cluster = {}
    ids = {}
    for gene in genes1:
        if "#" in gene: continue
        if gene.strip().split("\t")[14]:
            ids[gene.strip().split("\t")[1]] = gene.strip().split("\t")[14]
        else:
            ids[gene.strip().split("\t")[1]] = gene.strip().split("\t")[0] + "_" + gene.strip().split("\t")[1] + "_" + "unknown"

    for gene in genes2:
        if "#" in gene: continue
        if gene.strip().split("\t")[14]:
            ids[gene.strip().split("\t")[1]] = gene.strip().split("\t")[14]
        else:
            ids[gene.strip().split("\t")[1]] = gene.strip().split("\t")[0] + "_" + gene.strip().split("\t")[1] + "_" + "unknown"

    for gene in genes3:
        if "#" in gene: continue
        if gene.strip().split("\t")[14]:
            ids[gene.strip().split("\t")[1]] = gene.strip().split("\t")[14]
        else:
            ids[gene.strip().split("\t")[1]] = gene.strip().split("\t")[0] + "_" + gene.strip().split("\t")[1] + "_" + "unknown"

    for line in clus:
        if "chr" in line:
            continue
        if line.strip().split("\t")[21] not in cluster:
            try:
                cluster[line.strip().split("\t")[21]] = [ids[line.strip().split("\t")[1]]]
            except:
                cluster[line.strip().split("\t")[21]] = [gene.strip().split("\t")[0] + "_" + gene.strip().split("\t")[1] + "_" + "unknown"]
        else:
            try:
                cluster[line.strip().split("\t")[21]] = cluster[line.strip().split("\t")[21]] + [ids[line.strip().split("\t")[1]]]
            except:
                cluster[line.strip().split("\t")[21]] = cluster[line.strip().split("\t")[21]] + [gene.strip().split("\t")[0] + "_" + gene.strip().split("\t")[1] + "_" + "unknown"]


    for c in cluster.items():
        print(c[0] + "\t" + "\t".join(c[1]), file = output)
    
