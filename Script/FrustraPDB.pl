use strict;
use File::Copy;
use Bio::SeqIO;

open(Lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
my @sp;
my $pathFrustra="/home/maria/bin/Frustratometer/frustratometer2";

while(my $PDB=<Lista>){
	chomp $PDB;
	@sp= split "_", $PDB;
	my @sperror= split "", $PDB;
	if(@sperror[0]eq">"){}	
	else{		
		my $tam=@sp;
		system("cp /home/maria/Desktop/PDBs/@sp[0].pdb @ARGV[0]/OutPutFiles@ARGV[1]/@sp[0].pdb");
		#system ("wget 'http://www.rcsb.org/pdb/files/@sp[0].pdb' -O @ARGV[0]/OutPutFiles@ARGV[1]/@sp[0].pdb");
		if($tam==2){
			system ("perl @ARGV[0]/Script/ChainSeparate.pl @sp[0] @sp[1] @ARGV[0] @ARGV[1]");
			}
		else{
			system ("perl @ARGV[0]/Script/ChainSeparate.pl @sp[0] @sp[1] @ARGV[0] @ARGV[1] @sp[2] @sp[3]");
			}
		system("cp @ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0].pdb $pathFrustra/@sp[0]_@sp[1].pdb");
		system ("cd $pathFrustra; perl RunFrustratometer.pl @sp[0]_@sp[1].pdb singleresidue");	
		system("mv $pathFrustra/@sp[0]_@sp[1].pdb.done @ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done");
		system("mv $pathFrustra/@sp[0]_@sp[1].pdb @ARGV[0]/OutPut@ARGV[1]/PDB/@sp[0]_@sp[1].pdb");
		system("cp @ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done/FrustrationData/@sp[0]_@sp[1].pdb_singleresidue @ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done/FrustrationData/@sp[0].pdb_singleresidue");
		system("rm -r /home/maria/frustratometer2/@sp[0]_@sp[1].pdb.done");
		
	}
}	
close(Lista);

#----ChangesInAligment---

system("perl @ARGV[0]/Script/FixAlign.pl @ARGV[0] @ARGV[1]");
system("perl @ARGV[0]/Script/VerificaFrustra.pl @ARGV[0] @ARGV[1]");

#
system ("perl @ARGV[0]/Script/DeleteGaps.pl @ARGV[0] @ARGV[1]");

#---------HHMSearch----

system ("hmmbuild --amino @ARGV[0]/OutPutFiles@ARGV[1]/familias.hmm @ARGV[0]/OutPutFiles@ARGV[1]/AlignClean.fasta");
system ("hmmsearch --domtblout @ARGV[0]/OutPutFiles@ARGV[1]/salida @ARGV[0]/OutPutFiles@ARGV[1]/familias.hmm @ARGV[0]/OutPutFiles@ARGV[1]/AlignClean.fasta");

open(hmmsal,"@ARGV[0]/OutPutFiles@ARGV[1]/salida");

#-- changes in alignment

my $in=0;
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

my $alignment="@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta";

my $secuencia = Bio::SeqIO -> new(
	-format => "fasta",
	-file => "$alignment");
my $seq;

while (my $SEQ = $secuencia->next_seq()){
	$seq=$SEQ->seq();
	my @splitter= split "",$seq;
	if($SEQ->display_id eq $pdbidsal){
			last;
	}
}

close(alignA);


open(align, "@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta");

print sal ">$pdbidsal\n$seq\n";

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
open(align, "@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");

while(my $line=<align>){
	print sal "$line";
}

close(align);
close(sal);

#--- Missing Residuos 

if(@ARGV[2] eq "Y"){
	system ("perl @ARGV[0]/Script/MissingComplete.pl @ARGV[0] @ARGV[1] @sp[2]");
	system ("perl @ARGV[0]/Script/ChangeAlign.pl @ARGV[0] @ARGV[1]");
}
else{
	system("cp @ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta @ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");
	system("cp @ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta @ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign4.fasta");
}

