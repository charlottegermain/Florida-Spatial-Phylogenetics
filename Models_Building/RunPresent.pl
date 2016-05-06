#!/usr/bin/perl -w


#system "ls new_* > filenames";
open FH, "<filenames";
$num = 0;
while (<FH>)
{
    if (/(\S+)\_ValuesNoBG.csv/)
    {
	$file = $1;
	$num++;
#	print "$file\n";
#	print "$num\n";
	if ($num >0  && $num < 1550)
	{
	    print "file is present100.$num.sh\n";
	    open OUT, ">present100\.$num\.sh";
	    print OUT "\#!/bin/bash\n\n\#PBS -N maxent_$file\n #PBS -M cgermain\@ufl.edu\n \#PBS -m a\n \#PBS -j oe \n \#PBS -l walltime=1:00:00\n\#PBS -l pmem=4gb\n\#PBS -l nodes=1:ppn=1\n\n";
	    print OUT "cd /scratch/lfs/cgermain/MAXENT/Mask_Yearly/Present100Out2\n";
	    print OUT "mkdir presentMask100Yearly2\.$file\.OUT\n";
	    print OUT "module load java\n\n";
	    print OUT "export DISPLAY=:1\nXvfb :1 -screen 0 1024x768x16 &\n";
	    print OUT "export \_JAVA\_OPTIONS=\"-Xms128m -Xmx1024m\"\n";
	    print OUT "java -jar maxent.jar -e /scratch/lfs/cgermain/MAXENT/Mask_Yearly/Background100/$file\_background100.csv -j /scratch/lfs/cgermain/MAXENT/Mask_Yearly/Mask0212/$file -s /scratch/lfs/cgermain/MAXENT/Mask_Yearly/ValuesNoBG/$file\_ValuesNoBG.csv -o /scratch/lfs/cgermain/MAXENT/Mask_Yearly/Present100Out2/presentMask100Yearly2.$file\.OUT  -t geo -a -b 2 replicates=10  -X 25 'applyThresholdRule=Equal training sensitivity and specificity' warnings=False -z outrun no warnings notooltips redoifexists";
	    close OUT;
	    system "qsub present100\.$num\.sh";
	}
    }
}
