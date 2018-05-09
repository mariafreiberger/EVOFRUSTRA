use strict;
use File::Copy;

open(Lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
my @sp;

while(my $PDB=<Lista>){
	chomp $PDB;
	@sp= split "_", $PDB;
	my @sperror= split "", $PDB;
	if(@sperror[0]eq">"){}	
	else{		
		my $tam=@sp;
		copy("/home/maria/Desktop/PDBs/@sp[0].pdb","@ARGV[0]/OutPutFiles@ARGV[1]/@sp[0].pdb");
		#system ("wget 'http://www.rcsb.org/pdb/files/@sp[0].pdb' -O @ARGV[0]/OutPutFiles@ARGV[1]/@sp[0].pdb");
		if($tam==2){
			system ("perl @ARGV[0]/Script/ChainSeparate.pl @sp[0] @sp[1] @ARGV[0] @ARGV[1]");
			}
		else{
			system ("perl @ARGV[0]/Script/ChainSeparate.pl @sp[0] @sp[1] @ARGV[0] @ARGV[1] @sp[2] @sp[3]");
			}
		copy("@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0].pdb","/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb");
		system ("cd /home/maria/bin/Frustratometer/frustratometer2; perl RunFrustratometer.pl @sp[0]_@sp[1].pdb singleresidue");
		move("/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb.done","@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@sp[0]_@sp[1].pdb.done");
		move("/home/maria/bin/Frustratometer/frustratometer2/@sp[0]_@sp[1].pdb","@ARGV[0]/OutPut@ARGV[1]/PDB/@sp[0]_@sp[1].pdb");
		#sleep(5);
		#system ("rm -r /home/maria/bin/Frustratometer/frustratometer2/@sp[0].B99990001.pdb");
	}
}	
close(Lista);
system("perl @ARGV[0]/Script/FixAlign.pl @ARGV[0] @ARGV[1]");
system("perl @ARGV[0]/Script/VerificaFrustra.pl @ARGV[0] @ARGV[1]");

if(@ARGV[2] eq "Y"){
	system ("perl @ARGV[0]/Script/MissingComplete.pl @ARGV[0] @ARGV[1] @sp[2]");
	system ("perl @ARGV[0]/Script/ChangeAlign.pl @ARGV[0] @ARGV[1]");
}
else{
	copy("@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta","@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");
}
