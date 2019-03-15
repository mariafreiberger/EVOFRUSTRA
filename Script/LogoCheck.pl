use strict;

open(res, "@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/AllSalidaSResB.txt");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/AllSalidaSRes.txt");

while(my $res=<res>){
	chomp $res;
	my @spliiter= split " ", $res;
	my $tam=@spliiter;
	if($tam<5){

	}
	else{
		print sal "$res\n";
		}
}

close(res);
close(sal);
