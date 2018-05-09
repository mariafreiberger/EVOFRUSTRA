use strict;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/Posiciones");

while(my $align=<align>){
	my $Sres;
	my @splitalign=split "",$align;	
	if(@splitalign[0]eq">"){
		open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/SalidaSRes@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].txt");
		open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].pdb.done/FrustrationData/@splitalign[1]@splitalign[2]@splitalign[3]@splitalign[4]_@splitalign[6].pdb_singleresidue");
		$Sres=<Sres>;
			}
	else{
		my @splitalignes=split " ",$align;
		my $ter=0;
		my $tam=@splitalignes;
		while($ter<$tam){
			$ter++;
			if((@splitalignes[$ter-1] eq "G") or (@splitalignes[$ter-1] eq "Z")){
				print salida "$ter	N/A	N/A	N/A	N/A\n";
						}
			else{	
				$Sres=<Sres>;
				chomp $Sres;
				my @splitterSres=split " ",$Sres;
				if(@splitterSres[0] != @splitalignes[$ter-1]){
						my $r=1;
						while($r){
							$Sres=<Sres>;
							chomp $Sres;
							@splitterSres=split " ",$Sres;
							if(@splitterSres[0] == @splitalignes[$ter-1]){
									$r=0;	
								}
						}
					}
				else{
					print salida "$ter	@splitterSres[0]	@splitterSres[3]	@splitterSres[7]	";		
					if(@splitterSres[7]>0.55){print salida "MIN\n";}
					else{
						if(@splitterSres[7]>-1){print salida "NEU\n";}
						else{print salida "MAX\n";}
								}							
					}
				}
			}
	}
	close(sal);	
	}
close(align);
close(Sres);
