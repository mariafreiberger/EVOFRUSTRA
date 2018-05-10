use strict;
use File::Copy;

open(blista,"@ARGV[0]/OutPutFiles@ARGV[1]/Sequences.fasta");
open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

my $pdb;

while(my $lineB=<blista>){
	chomp $lineB;
	$lineB =~ tr/a-z/A-Z/;
	system("awk '\$2 ~ /$lineB/' @ARGV[0]/DBSeq.fasta > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	my $awk=<awk>;
	chomp $awk;
	my @spa= split " ",$awk; 
	my @sp= split "_",@spa[0];
	print salida "@spa[0]\n";
	copy("/home/maria/Desktop/PDBs/@sp[0].pdb","@ARGV[0]/OutPutFiles@ARGV[1]/@sp[0].pdb");
	system ("perl @ARGV[0]/Script/ChainSeparate.pl @sp[0] @sp[1] @ARGV[0] @ARGV[1]");
	copy("@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0].pdb","/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb");
	system ("cd /home/maria/bin/Frustratometer/frustratometer2; perl RunFrustratometer.pl @sp[0]_@sp[1].pdb singleresidue");
	move("/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb.done","@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done");
	move("/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb","@ARGV[0]/OutPut@ARGV[1]/PDB/@sp[0]_@sp[1].pdb");
	copy("@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done/FrustrationData/@sp[0]_@sp[1].pdb_singleresidue","@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done/FrustrationData/@sp[0].pdb_singleresidue");
}
system("perl @ARGV[0]/Script/FixAlign.pl @ARGV[0] @ARGV[1]");
system("perl @ARGV[0]/Script/VerificaFrustra.pl @ARGV[0] @ARGV[1]");

if(@ARGV[2] eq "Y"){
	system ("perl @ARGV[0]/Script/MissingComplete.pl @ARGV[0] @ARGV[1]");
	system ("perl @ARGV[0]/Script/ChangeAlign.pl @ARGV[0] @ARGV[1]");
}
else{
	copy("@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta","@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");
}
close(blista);
close(seq);
