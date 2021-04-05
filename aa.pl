
open(AA, "<aaindex1.dat");

$count=0;

while(<AA>){
	if($_ =~ /^\s\s/){
		$value.=substr($_,0,100);
	}
	if($_ =~ /^\/\//){
		printf $value."\n";
		$count++;
		$value="";
	}
}
printf $count."\n";
print chr(7);	#終了時に音が鳴ります
