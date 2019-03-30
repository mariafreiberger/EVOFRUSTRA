use strict;

my $fastafile=$ARGV[1];
my $jobID=$ARGV[0];
my $jobsDir=qx(pwd);
chomp $jobsDir;

system("rm -r $jobsDir/OutPutFiles$jobID");
system("rm -r $jobsDir/OutPut$jobID");

print "Considers Missing Residues (Y/N): "; #Sequence, are from UniProt(Y) o PDB(N)?
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

#--- Make directories----

system("mkdir $jobsDir/OutPutFiles$jobID"); 
system("mkdir $jobsDir/OutPutFiles$jobID/Modeller");
system("mkdir $jobsDir/OutPutFiles$jobID/Equivalences");
system("mkdir $jobsDir/OutPut$jobID");
system("mkdir $jobsDir/OutPut$jobID/PDB");
system("mkdir $jobsDir/OutPut$jobID/VisualizationScript");

#--- Copy files ---

system("cp $jobsDir/Script/Generator.R $jobsDir/OutPutFiles$jobID/Equivalences/Generator.R");
system("cp $jobsDir/Script/SeqLogo.R $jobsDir/OutPutFiles$jobID/Equivalences/SeqLogo.R");
system("cp $jobsDir/Script/Logo.R $jobsDir/OutPutFiles$jobID/Equivalences/Logo.R");

my $c=0;
my $n=0;

#--- Changing Alignment --- 

open(salidafasta,">$jobsDir/OutPutFiles$jobID/Sequences.fasta"); # Sequences without gaps 
open(sfasta,"$jobsDir/$fastafile"); # Input Alignment 
open(alin,">$jobsDir/OutPutFiles$jobID/Alignment.fasta"); # Alignment without \n
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

my $tamanio=@ARGV;


if($tamanio<3){ 
		system("perl $jobsDir/Script/FindPDB.pl $jobsDir $jobID"); #Find the pdbid (in case you are running without a list like input)
	} 
else{
	open(listapdb,"$jobsDir/@ARGV[2]"); #Passing all in lower case, expect chain.
	open(salpdb,">$jobsDir/OutPutFiles$jobID/ListaPDB.txt");
	while(my $listapdb=<listapdb>){
		chomp $listapdb;
		my @splitm=split "_",$listapdb;
		@splitm[0]=lc(@splitm[0]);
		my @spos=split "-", @splitm[2];
		my $ta=@splitm;
		if($ta>2){
			print salpdb "@splitm[0]_@splitm[1]_@splitm[2]_@splitm[3]\n";
			}
		else{
			print salpdb "@splitm[0]_@splitm[1]\n";
		}
	}
}

#--- Run Frustration --- 

system("perl $jobsDir/Script/FrustraPDB.pl $jobsDir $jobID $missa");


#----Equivalences---

system ("perl $jobsDir/Script/FinalAlign.pl $jobsDir $jobID");
system ("perl $jobsDir/Script/Equivalences.pl $jobsDir $jobID");


#-- Call all .R scripts---

system("perl $jobsDir/Script/FastaMod.pl $jobsDir $jobID");
system("cp $jobsDir/OutPutFiles$jobID/long.txt $jobsDir/OutPutFiles$jobID/Equivalences/long.txt");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; cat *SalidaSRes* > AllSalidaSResB.txt");
system("perl $jobsDir/Script/LogoCheck.pl $jobsDir $jobID");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; Rscript Logo.R");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; Rscript Generator.R");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; Rscript SeqLogo.R");
system("perl $jobsDir/Script/VScript.pl $jobsDir $jobID");

system("cp $jobsDir/OutPutFiles$jobID/Equivalences/HistogramFrustration.svg $jobsDir/OutPut$jobID/HistogramFrustration.svg");

system("cp $jobsDir/OutPutFiles$jobID/SalidaAlign.fasta $jobsDir/OutPut$jobID/SalidaAlign.fasta"); 
system("cp $jobsDir/OutPutFiles$jobID/SinPDB.txt $jobsDir/OutPut$jobID/SinPDB.txt");
system("cp $jobsDir/OutPutFiles$jobID/ListaPDBC.txt $jobsDir/OutPut$jobID/ListaPDB.txt");
system("cp $jobsDir/OutPutFiles$jobID/Equivalences/CharactPosDataN $jobsDir/OutPut$jobID/CharactPosDataN");
system("cp $jobsDir/OutPutFiles$jobID/Equivalences/IC.csv $jobsDir/OutPut$jobID/IC.csv");
system("cp $jobsDir/OutPutFiles$jobID/familias.hmm $jobsDir/OutPut$jobID/familias.hmm");
system("cp $jobsDir/OutPutFiles$jobID/Equivalences/seqlogo.png $jobsDir/OutPut$jobID/seqlogo.png");

system("cd $jobsDir; tar -zcvf OutPut$jobID.tar.gz OutPut$jobID");

#sleep(60);

#system("cd $jobsDir; rm -r OutPutFiles$jobID");
#system("cd $jobsDir; rm -r OutPut$jobID");
