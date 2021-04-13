
open(AA, "<aaindex1.dat");

$count=0;
$I=0;

while(<AA>){
	if($_ =~ /^I/){
		$I=1;
	}
	if($_ =~ /^\s\s/ && $I==1){
		$value.=substr($_,0,100);
	}
	if($_ =~ /^\/\//){
		@index=split(/\s/,$value);
		for($j=0;$j<@index;$j++){
			printf $index[$j];
		}
		printf "\n";
		$count++;
		$value="";
		$I=0;
	}
}
printf $count."\n";
print chr(7);	#終了時に音が鳴ります
