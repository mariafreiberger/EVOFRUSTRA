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

open(align, "$jobsDir/$fastafile");
my $c=0;
my $n=0;

open(lista,">$jobsDir/OutPutFiles$jobID/Lista.txt");
open(salidafasta,">$jobsDir/OutPutFiles$jobID/Sequences.fasta");
open(alin,">$jobsDir/OutPutFiles$jobID/AlignSE.fasta");
my $co=0;

while(my $line=<align>)
{
	chomp $line;
	my @sp=split "", $line;	
	if (@sp[0]eq">"){
		$c++;
		$n=0;
		print blast ">Seq$c\n";
		print lista "Seq$c\n";
		if($c==1){print alin ">Seq$c\n";}
		else{
			print alin "\n>Seq$c\n";
			print salidafasta "\n";			
			}
		}
	else {
		my $tam=@sp;
		$co=0;
		while ($co<$tam){
			if(@sp[$co]eq"-"){
				print alin "@sp[$co]";
				$co++;}
			else{
				if($n==49){
					print blast "\n";
					$n=0;
						}			
				print blast "@sp[$co]";
				print alin "@sp[$co]";
				print salidafasta "@sp[$co]";
				$co++;
				$n++;
				}
			}
		
		}
}


close(blast);
close(align);
close(lista);
close(alin);

my $tamanio=@ARGV;

if($tamanio<3){
	system("perl $jobsDir/Script/FindPDB.pl $jobsDir $jobID");
		}
else{
		copy("/home/maria/Desktop/AutoLogo/@ARGV[2]","/home/maria/Desktop/AutoLogo/OutPutFiles$jobID/ListaPDB.txt");

}

#----ChangesInAligment---

system("perl $jobsDir/Script/FixAlign.pl $jobsDir $jobID");
system ("perl $jobsDir/Script/DeleteGaps.pl $jobsDir $jobID");

#---------HHMSearch----

system ("hmmbuild --amino $jobsDir/OutPutFiles$jobID/familias.hmm $jobsDir/OutPutFiles$jobID/AlignClean.fasta");
system ("hmmsearch --domtblout $jobsDir/OutPutFiles$jobID/salida $jobsDir/OutPutFiles$jobID/familias.hmm $jobsDir/OutPutFiles$jobID/AlignClean.fasta");

open(hmmsal,"$jobsDir/OutPutFiles$jobID/salida");

my $in=0;
my $seq;
my $pdbidsal;

while(my $line=<hmmsal>){
	my @splitter= split "", $line;
	if(@splitter[0]eq"#"){}
	else{
		my @spline= split " ", $line;
		$pdbidsal=@spline[0];
		last;
	}
}

open(alignA, "$jobsDir/OutPutFiles$jobID/Alignment.fasta");

while(my $linealig=<alignA>){
	chomp $linealig;
	chomp $linealig;
	my @spalig= split "", $linealig;
	my @aux=split " ", $linealig;
	my @spaliges= split ">", @aux[0];
	if(@spalig[0] eq ">"){
		print sa "@spaliges[1]eq $pdbidsal\n";
		if(@spaliges[1] eq $pdbidsal){
			$seq=<alignA>;
			print sa "@spaliges[1] $seq";
			last;
		}
	}
}

close(alignA);

open(align, "$jobsDir/OutPutFiles$jobID/Alignment.fasta");
open(sal,">$jobsDir/OutPutFiles$jobID/SeqAlign.fasta");

print sal ">$pdbidsal\n$seq";

while(my $line=<align>){
	chomp $line;
	my @sp=split "", $line;
	if (@sp[0]eq">"){		
		my @spaux=split ">", $line;
		if(@spaux[1]eq$seq){
			print sal "$line\n";
			$line=<align>;
			print sal "$line\n";
			}
		}

}
close(align);
open(align, "$jobsDir/OutPutFiles$jobID/Alignment.fasta");

while(my $line=<align>){
	print sal "$line";
}

close(align);
close(sal);

#-------Frustration-----


open(Lista,"$jobsDir/OutPutFiles$jobID/ListaPDB.txt");

while(my $PDB=<Lista>){
	chomp $PDB;
	my @sp= split "_", $PDB;
	my @sperror= split "", $PDB;
	if(@sperror[0]eq">"){}
	else{		
		my $tam=@sp;
		copy("/home/maria/Desktop/PDBs/@sp[0].pdb","$jobsDir/OutPutFiles$jobID/@sp[0].pdb");
		#system ("wget 'http://www.rcsb.org/pdb/files/@sp[0].pdb' -O $jobsDir/OutPutFiles$jobID	/@sp[0].pdb");
		if($tam==2){
			system ("perl $jobsDir/Script/ChainSeparate.pl @sp[0] @sp[1] $jobsDir $jobID");
			}
		else{
			system ("perl $jobsDir/Script/ChainSeparate.pl @sp[0] @sp[1] $jobsDir $jobID @sp[2] @sp[3]");
			}
		copy("$jobsDir/OutPutFiles$jobID/Modeller/@sp[0].pdb","/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb");
		system ("cd /home/maria/bin/Frustratometer/frustratometer2; perl RunFrustratometer.pl @sp[0]_@sp[1].pdb singleresidue");
		move("/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb.done","$jobsDir/OutPutFiles$jobID/Modeller/@sp[0]_@sp[1].pdb.done");
		move("/home/maria/bin/Frustratometer/frustratometer2/@sp[0].pdb","$jobsDir/OutPut$jobID/PDB/@sp[0]_@sp[1].pdb");
		#sleep(5);
		#system ("rm -r /home/maria/bin/Frustratometer/frustratometer2/@sp[0].B99990001.pdb");
	}
}	
close(Lista);

#----Equivalences---
system ("perl $jobsDir/Script/VerificaFrustra.pl $jobsDir $jobID");
if($missa eq "Y"){
	system ("perl $jobsDir/Script/MissingComplete.pl $jobsDir $jobID");
	system ("perl $jobsDir/Script/ChangeAlign.pl $jobsDir $jobID");
}
else{
	copy("$jobsDir/OutPutFiles$jobID/SeqAlign.fasta","$jobsDir/OutPutFiles$jobID/SeqAlign3.fasta");
}
system ("perl $jobsDir/Script/FinalAlign.pl $jobsDir $jobID");
system ("perl $jobsDir/Script/Equivalences.pl $jobsDir $jobID");

#--LLamar a todos los .R---

system("perl $jobsDir/Script/FastaMod.pl $jobsDir $jobID");
copy ("$jobsDir/OutPutFiles$jobID/long.txt","$jobsDir/OutPutFiles$jobID/Equivalences/long.txt");
system("cd $jobsDir/OutPutFiles$jobID/Equivalences; cat *SalidaSRes* > AllSalidaSRes.txt");
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
