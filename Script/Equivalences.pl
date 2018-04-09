use strict;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/Posiciones");

while(my $align=<align>){
	my @splitalign=split "",$align;	
	if(@splitalign[0]eq">"){
		open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/SalidaSRes@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].txt");
		open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].pdb.done/FrustrationData/@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4].B99990001.pdb_singleresidue");
		my $Sres1=<Sres>;
			}
	else{
		my @splitalignes=split " ",$align;
		my $ter=0;
		my $tam=@splitalignes;
		while($ter<$tam){
			if(@splitalignes[$ter]==0){
				$ter++;
				print salida "$ter	N/A	N/A	N/A	N/A\n";
						}
			else{	
				my $Sres=<Sres>;
				my @splitterSres=split " ",$Sres;
				if(@splitterSres[0] eq ""){
					$ter++;
					print salida "$ter	N/A	N/A	N/A	N/A\n";
						}	
				if(@splitterSres[0]==@splitalignes[$ter]){
					$ter++;
					if(@splitterSres[2] eq ""){
						print salida "$ter	N/A	N/A	N/A	N/A\n";
						}	
					else{				
					print salida "$ter	@splitterSres[0]	@splitterSres[2]	@splitterSres[6]	";
					if(@splitterSres[6]>0.55){print salida "MIN\n";}
					else{
						if(@splitterSres[6]>-1){print salida "NEU\n";}
						else{print salida "MAX\n";}
								}							
							}
						}
					}
				}
		}
	
close(sal);	
	}
close(align);
close(Sres);
