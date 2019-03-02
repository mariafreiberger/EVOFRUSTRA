use strict;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign4.fasta");
open(nuevo,">@ARGV[0]/OutPutFiles@ARGV[1]/SalidaAlign.fasta");
open(nuevo2,">@ARGV[0]/OutPutFiles@ARGV[1]/SalidaAlignSE.fasta");
open(posi,">@ARGV[0]/OutPutFiles@ARGV[1]/Posiciones");

my $c=0;
my @vector;
my $m=0;
my $j;
my $control=0;
my @splres;
my @slista;
my $r=0;
my $align;
my @s;
my $f=0;
my $chq=0;

while($align=<align>){
	chomp $align;
	my $sres;
	my $co;
	if ($c==0){
		$c++;}
	else{	
		my @splitter= split "",$align;
		my $tam = @splitter;
		if($control==0){
			$tam = @splitter;
			$control++;
				}
		if($c==1)
		{	$c++;
			my $i=0;
			while($i<$tam){
				if((@splitter[$i]eq"-") or (@splitter[$i]eq"Z")){
					@vector[$i]=0;
					}
				else{
					@vector[$i]=1;
					}
				$i++;
				}
			}
		else{
			if(@splitter[0]eq">"){
				open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6].pdb.done/FrustrationData/@splitter[1]@splitter[2]@splitter[3]@splitter[4].pdb_singleresidue");
				$f=0;
				$sres=<Sres>;
				@slista=split "_",$align;
				$r=1;
				if($m==0){
					print nuevo ">@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					print nuevo2 ">@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";	
					print posi "$align\n";	
					print "\n$align\n";
					$m++;
					
					}
				else{
					print nuevo "\n>@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					print nuevo2 "\n>@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					print posi "\n$align\n";
					print "\n$align\n";
					}
		
			}	
			else {
				if(($r==1) and (@slista[2] ne "")){
					$sres=<Sres>;
					$chq=1;
					@s=split " ",$sres;
					$r=@s[0];
					if(@s[0]==@slista[2]){$r++;
						print "$sres";
						}
					else{	
						while($r<@slista[2]-1){
							$sres=<Sres>;
							print "$sres";
							$r++;
							}
						}
					}	
				my $tam = @splitter;
				my $j=0;
				my $n=0;
				my $q=0;
				while ($j<$tam){
					if(@vector[$j]==0){
						if(@splitter[$j] ne "-"){
							@splres= split " ",$sres;	
							if((@splres[0] == @s[0]) and ($f==0)){
									$f=1;			
									}
								else{
									$sres=<Sres>;
									}
							}
						}
					else{
						if(@splitter[$j]eq"Z"){
							print nuevo "-";
							$n++; $q++;
							print nuevo2 "-";
							}
						else{
							print nuevo "@splitter[$j]";
							$n++; $q++;
							print nuevo2 "@splitter[$j]";
							}
						if($n==51){
							print nuevo "\n";
							$n=0;			
								}
						if(@splitter[$j]eq"-"){
							print posi "G ";
							}
						else{	
							if(@splitter[$j]eq"Z"){
								print posi "Z ";
								@splres= split " ",$sres;
								if((@splres[0] == @s[0]) and ($f==0)){
									$f=1;			
									}
								else{
									$sres=<Sres>;
									}
								}
							else{	
								@splres= split " ",$sres;
								if((@splres[0] == @s[0]) and ($f==0)){
									$f=1;			
									}
								else{
									$sres=<Sres>;
									}
								$r++;
								@splres= split " ",$sres;
								print posi "@splres[0] ";
									
								}	
							}
					
						}
					$j++;
					
					}
				}
			}
		}

}

system ("perl @ARGV[0]/Script/longalign.pl @ARGV[0] @ARGV[1]");
close(align);
close(nuevo);
close(nuevo2);
close(posi);
