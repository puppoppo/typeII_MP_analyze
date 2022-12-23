
open(SWISS, "uniprot_sprot.dat");
open(WRITE,">memcount.csv");

$, = ",";
$\ = "\n";
$U=0;	#配列にU,Xが含まれているかフラグ化
$A=0;

while(<SWISS>){
	chomp;

	if($_ =~ /^ID   /){
		$swissid = substr($_,5,12);
		$swissid =~ s/\s//g;
	}
	 elsif($_ =~ /^DE/){
		if($_ =~ /^DE   RecName: Full=/){
			$swissde .= substr($_,19,100);
		}
		if($_ =~ /Fragment/){
			$frag = 1;
		}
	}
	elsif($_ =~ /^OC   /){
		$swissoc .= substr($_,5,100);
	}

	elsif($_ =~ /^CC   -!- SUBCELLULAR LOCATION/){
	$suswitch = 1;
	$swisssu .= substr($_,9,100);
	}
	elsif($_ =~ /^CC   -!-|CC   ---/){
		$suswitch = 0;
	}
	elsif($_ =~ /^CC       / && $suswitch == 1){
		$swisssu .= substr($_,9,100);
	}
	elsif($_ =~/^FT   TRANSMEM/){	#出力はしてないけどTMR残基を格納しています
		$FT=1;
	}
	elsif($_ =~ /^     /){	#配列にU,Xが含まれているかフラグ化
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
	}

	elsif($_ =~ /^\/\//){
		if($swissoc =~ /homo/){
			if($swisssu =~ /membrane |Membrane /){
				printf WRITE "1,".$FT."\n";
			}else{
				printf WRITE "0,".$FT."\n";
			}
		}
		$FT=0;
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$swisssu = "";
		$swisssq = "";
		$U=0;
	}
}

print chr(7);	#終了時に音が鳴ります
