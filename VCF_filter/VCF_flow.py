import sys
#input VCF
vcf_path = sys.argv[1]

with open(vcf_path, 'r') as vcf_source, open('Re_formated.vcf', 'w+') as test:
	for line in vcf_source:
		if line.startswith('#'):
			print >> test, line.strip() 
		else:
			line_s = line.strip().split('\t')
			alts = line_s[4].split(',')
			#print line
			line_fin = line_s[9].split(':')
			line_fin[0] = '0/1'
			alleles = line_s[9].split(':')[1].split(',')[1:]
			alleles_rev = [alleles[1], alleles[0]]
			line_fin_b = line_fin[0] +':' +  ','.join(alleles) + ':' + ':'.join(line_fin[2:])
			line_fin_a = line_fin[0] +':' +  ','.join(alleles_rev) + ':' + ':'.join(line_fin[2:])
			line_out_a = '\t'.join(line_s[0:4]) + '\t' + alts[0] + '\t' + '\t'.join(line_s[5:9]) + '\t' + line_fin_a
			line_out_b = '\t'.join(line_s[0:4]) + '\t' + alts[1] + '\t' + '\t'.join(line_s[5:9]) + '\t' + line_fin_b
			print >> test, line_out_a
			print >> test, line_out_b


