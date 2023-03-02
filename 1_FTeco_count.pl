
open(SWISS, "typeII.dat");
open(WRITE,">1_FTeco_count.csv");

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
		$ftnumber++;
		$TMR = substr($_,21,100);
		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		$TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){	#FT TRANSMEM行の後ろ2行をfteviに格納
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^     /){	#配列にU,Xが含まれているかフラグ化
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
		if($_ =~/U|X/){
			$U=1;
		}
	}

	elsif($_ =~ /^\/\//){

		if($ftnumber == 1){
			if($swisssu =~ /type II |typeII /){

				@su=split(/\.|\;/,$swisssu);

				if($ftevi =~ /ECO:0000269/){$fteco=269;}
				elsif($ftevi =~ /ECO:0000303/){$fteco=303;}
				elsif($ftevi =~ /ECO:0000305/){$fteco=305;}
				elsif($ftevi =~ /ECO:0000250/){$fteco=250;}
				elsif($ftevi =~ /ECO:0000255/){$fteco=255;}
				elsif($ftevi =~ /ECO:0000256/){$fteco=256;}
				elsif($ftevi =~ /ECO:0000259/){$fteco=259;}
				elsif($ftevi =~ /ECO:0000312/){$fteco=312;}
				elsif($ftevi =~ /ECO:0000313/){$fteco=313;}
				elsif($ftevi =~ /ECO:0000244/){$fteco=244;}
				elsif($ftevi =~ /ECO:0000213/){$fteco=213;}

				@sq=();
				@sq=split(//,$swisssq);

				printf WRITE ">".$swissid.",".$fteco."\n";
				for($i=0;$i<@sq;$i++){
					printf WRITE $sq[$i];
				}
				printf WRITE "\n" ;
			}
		}
    $fteco=0;
		$swissid = "";
		$swissde = "";
		$frag = 0;
		$swissoc = "";
		$suswitch = 0;
		$swisssu = "";
		$swisssq = "";
		$CCeco=0;
		@sq = (0);
		$U=0;
		$ftnumber=0;
		$ftswitch=0;
		@su=(0);
		$t2eco=0;
		$note=0;
		$TMRstart=0;
		$TMRend=0;
		$ftevi="";
		$iso=0;
	}
}

print chr(7);	#終了時に音が鳴ります
