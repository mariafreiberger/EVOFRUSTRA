use strict;
use File::Copy;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDBC.txt");

my %hash = ("CYS" => "C", "ASP"=>"D", "SER"=>"S"
,"GLN"=>"Q","LYS"=>"K","ILE"=>"I","PRO"=>"P",
"THR"=>"T","PHE"=>"F","ASN"=>"N","GLY"=>"G","HIS"=>"H","LEU"=>"L","ARG"=>"R",
"TRP"=>"W","ALA"=>"A","VAL"=>"V","GLU"=>"E","TYR"=>"Y","MET"=>"M");

my $pdb;
my $ch;
my $pdbch;
my @com;
my $count=0;
my $comi;

while(my $alin=<align>){
	chomp $alin;
	my $cline=0;
	my $long=0;
	@com="";
	my @sp;
	my $ba=0;
	my $ta;
	my @splitter= split "",$alin;
	if (@splitter[0]eq">"){
		print sal "@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
		$pdb="@splitter[1]@splitter[2]@splitter[3]@splitter[4]";
		$ch=@splitter[6];
		$pdbch="@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]";
		my @splig= split "_",$alin;
		$comi=@splig[2];
		my $tc=@splig;
		$count=0;
		open(busca,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdb.pdb");
		while(my $busca=<busca>){
			my @busca= split " ", $busca;
			if((@busca[0] eq "REMARK")and(@busca[1]==465)and(@busca[3] eq $ch)){
				@com[$count]=@busca[4];
				$count++;
				}
			}
			close(busca);
		if($count==0){
			copy("@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.pdb.done/FrustrationData/$pdbch.pdb_singleresidue","@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.pdb.done/FrustrationData/$pdb.pdb_singleresidue");}
		else{
			
			open(sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.pdb.done/FrustrationData/$pdbch.pdb_singleresidue");
			open(sressal,">@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/$pdbch.pdb.done/FrustrationData/$pdb.pdb_singleresidue");
				my $cnt=0;
				my @spl;
				my $Sres=<sres>;
				print sressal "$Sres";
				while($Sres=<sres>){
					@spl= split " ",$Sres;
					if(@spl[0]>@com[$cnt]){
						while((@spl[0]-1>=@com[$cnt])and($count>$cnt)){
							print sressal "@com[$cnt] Missing Residue\n";
							$cnt++;					
								}
						print sressal "$Sres";
							}				
					else{
						print sressal "$Sres";
						}
					}
				if(@spl[0]<@com[$cnt]){
						while($cnt<=$count-1){
							print sressal "@com[$cnt] Missing Residue\n";
							$cnt++;					
								}
				}	
			}
	}	
close(sres);	
close(sressal);
}
close(align);
close(Sal);
