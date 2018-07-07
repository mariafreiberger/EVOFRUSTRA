use strict;
use File::Copy;

my $fastafile=$ARGV[1];
my $jobID=$ARGV[0];
my $jobsDir=qx(pwd);
chomp $jobsDir;

print "Considers Missing Residues (Y/N): ";
my $missa = <STDIN>;
chomp $missa;
$missa=uc($missa);
my $d=1;
while($d){
if(($missa eq "Y")or($missa eq "N")){
	$d=0;
	}
else{
	print "Considers Missing Residues (Y/N), please select a correct option: ";
	$missa = <STDIN>;
	chomp $missa;
	$missa=uc($missa);
	}
}


mkdir "$jobsDir/OutPutFiles$jobID";
mkdir "$jobsDir/OutPutFiles$jobID/Modeller";
mkdir "$jobsDir/OutPutFiles$jobID/Equivalences";
mkdir "$jobsDir/OutPut$jobID";
mkdir "$jobsDir/OutPut$jobID/PDB";
mkdir "$jobsDir/OutPut$jobID/VisualizationScript";

copy("$jobsDir/Script/Generator.R","$jobsDir/OutPutFiles$jobID/Equivalences/Generator.R");
copy("$jobsDir/Script/SeqLogo.R","$jobsDir/OutPutFiles$jobID/Equivalences/SeqLogo.R");
copy("$jobsDir/Script/Logo.R","$jobsDir/OutPutFiles$jobID/Equivalences/Logo.R");

my $c=0;
my $n=0;

open(salidafasta,">$jobsDir/OutPutFiles$jobID/Sequences.fasta");
open(sfasta,"$jobsDir/$fastafile");
open(alin,">$jobsDir/OutPutFiles$jobID/Alignment.fasta");
my $co=0;

while (my $sfasta=<sfasta>){
	chomp $sfasta;
	my @splitter= split "",$sfasta;
	$c++;
	if(@splitter[0] eq ">"){
		if($c==1){}
		else{
			print salidafasta "\n";
			print alin "\n";
			}
		print alin ">Seq$c\n";
	}
	else{
		$co=0;
		my $long=@splitter;
		while($co<$long){
			if(@splitter[$co] eq "-"){
				print alin "@splitter[$co]";
				}
			else{
					print alin "@splitter[$co]";
					print salidafasta "@splitter[$co]";
				}
			$co++;
			}
		
	}

}	
close(align);
close(lista);
close(alin);

copy ("$jobsDir/OutPutFiles$jobID/Alignment.fasta",">$jobsDir/OutPutFiles$jobID/AlignmentBis.fasta");

my $tamanio=@ARGV;

#----Frustra----

if($tamanio<3){
	print "Is it a protein domain? (Y/N): ";
	my $Dom = <STDIN>;
	chomp $Dom;
	$Dom=uc($Dom);
	my $d=1;
	while($d){
		if(($Dom eq "Y")or($Dom eq "N")){
			$d=0;
			}
		else{
			print "Is it a protein domain? (Y/N), please select a correct option: ";
			$Dom = <STDIN>;
			chomp $Dom;
			$Dom=uc($Dom);
			}
		}
	if($Dom eq "Y"){
		system("perl $jobsDir/Script/FindPDBDom.pl $jobsDir $jobID")
		}
	else{
		system("perl $jobsDir/Script/FindPDB.pl $jobsDir $jobID");
		}	
	}
else{
	copy("$jobsDir/@ARGV[2]","$jobsDir/OutPutFiles$jobID/ListaPDB.txt");
}

system("perl $jobsDir/Script/FrustraPDB.pl $jobsDir $jobID $missa");


#----Equivalences---

system ("perl $jobsDir/Script/FinalAlign.pl $jobsDir $jobID");
system ("perl $jobsDir/Script/Equivalences.pl $jobsDir $jobID");

sleep(10);

#--LLamar a todos los .R---

system("perl $jobsDir/Script/FastaMod.pl $jobsDir $jobID");
copy ("$jobsDir/OutPutFiles$jobID/long.txt","$jobsDir/OutPutFiles$jobID/Equivalences/long.txt");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; cat *SalidaSRes* > AllSalidaSResB.txt");
system("perl $jobsDir/Script/LogoCheck.pl $jobsDir $jobID");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; Rscript Logo.R");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; Rscript Generator.R");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; Rscript SeqLogo.R");
system("perl $jobsDir/Script/VScript.pl $jobsDir $jobID");

copy ("$jobsDir/OutPutFiles$jobID/Equivalences/HistogramFrustration.svg","$jobsDir/OutPut$jobID/HistogramFrustration.svg");

copy("$jobsDir/OutPutFiles$jobID/SalidaAlign.fasta","$jobsDir/OutPut$jobID/SalidaAlign.fasta"); #para el skyling
copy("$jobsDir/OutPutFiles$jobID/SinPDB.txt","$jobsDir/OutPut$jobID/SinPDB.txt");
copy("$jobsDir/OutPutFiles$jobID/ListaPDBC.txt","$jobsDir/OutPut$jobID/ListaPDB.txt");
copy("$jobsDir/OutPutFiles$jobID/Equivalences/CharactPosDataN","$jobsDir/OutPut$jobID/CharactPosDataN");
copy("$jobsDir/OutPutFiles$jobID/Equivalences/IC.csv","$jobsDir/OutPut$jobID/IC.csv");
copy("$jobsDir/OutPutFiles$jobID/familias.hmm","$jobsDir/OutPut$jobID/familias.hmm");
copy("$jobsDir/OutPutFiles$jobID/Equivalences/seqlogo.png","$jobsDir/OutPut$jobID/seqlogo.png");

system("cd $jobsDir; tar -zcvf OutPut$jobID.tar.gz OutPut$jobID");

#sleep(60);

#system("cd $jobsDir; rm -r OutPutFiles$jobID");
#system("cd $jobsDir; rm -r OutPut$jobID");
