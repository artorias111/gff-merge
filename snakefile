rule gff_merge:
	input:
		braker="{sample}.braker.gff",
		earlgrey="{sample}.earlgrey.gff"
	output:
		"{sample}.combined.sorted.gff"
	
	shell:
		"""
		# 1. Take the header from just one of the files to create the new output file
		grep '^##' {input.braker} > {output}
		
		# 2. Combine the DATA from both files, sort it, and APPEND (>>) it to the output file
		grep -v '^##' {input.braker} {input.earlgrey} | sort -k1,1 -k4,4n >> {output}
		"""