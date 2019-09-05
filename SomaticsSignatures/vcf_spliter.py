# author: Yifei.wan

# split two samples into separated VCF files

import sys

def output_generator(vcf, output_path):
    line = vcf.readline()
    while line:
        if line.startswith("#CHROM"):
            output1 = output_path + "/" + line.strip().split("\t")[-2] + ".vcf"
            output2 = output_path + "/" + line.strip().split("\t")[-2] + "_" +  line.strip().split("\t")[-1] + ".vcf"
            break
        else:
            line = vcf.readline()
    vcf.seek(0)
    return output1, output2

def spliter(vcf, file1, file2):
    line = vcf.readline()
    while line:
        if line.startswith("##"):
            print(line.strip(), file = file1)
            print(line.strip(), file = file2)
            line = vcf.readline()
        elif line.startswith("#CHROM"):
            sample1 = line.strip().split("\t")[-2]
            sample2 = line.strip().split("\t")[-1]
            col_com = line.strip().split("\t")[0:-2]
            line1 = col_com + [sample1]
            line2 = col_com + [sample2]
            print("\t".join(line1), file = file1)
            print("\t".join(line2), file = file2)
            line = vcf.readline()
        else:
            col_com = line.strip().split("\t")[0:8]
            sample1 = line.strip().split("\t")[9]
            sample2 = line.strip().split("\t")[10]
            line1 = col_com + [sample1]
            line2 = col_com + [sample2]
            print("\t".join(line1), file = file1)
            print("\t".join(line2), file = file2)
            line = vcf.readline()
            
            
def main():
    input_vcf = sys.argv[1]
    output_path = sys.argv[2]
    with open(input_vcf, "r") as vcf:
        output1, output2 = output_generator(vcf, output_path)
        with open(output1, "w+") as file1, open(output2, "w+") as file2:
            spliter(vcf, file1, file2)
    
if __name__ == "__main__":
    main()
