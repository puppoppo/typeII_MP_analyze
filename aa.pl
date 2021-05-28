
open(AA, "<aaindex1.dat");
open(OUT, ">aaindex.csv");
$count=0;
$I=0;

printf OUT "Hline,A,R,N,D,C,Q,E,G,H,I,L,K,M,F,P,S,T,W,Y,V\n";

while(<AA>){
	if($_ =~ /^H/){
		$Hline=substr($_,2,100);
	}
	elsif($_ =~ /^I/){
		$I=1;
	}
	elsif($_ =~ /^\s\s/ && $I==1){
		$value.=substr($_,0,100);
	}
	elsif($_ =~ /^\/\//){
		@index=split(/\s/,$value);
		# for($j=0;$j<@index;$j++){
		# 	printf $index[$j];
		# }
		# printf "\n";
		$count++;
		$value="";
		$I=0;

	}
}
printf $count."\n";
print chr(7);	#終了時に音が鳴ります
