
open(SWISS, "typeII.dat");
open(WRITE,">1_FTeco_count.csv");

$, = ",";
$\ = "\n";

while(<SWISS>){
	chomp;

	if($_ =~ /^ID   /){
		$swissid = substr($_,5,12);
		$swissid =~ s/\s//g;
	}
	elsif($_ =~/^FT   TRANSMEM/){	#出力はしてないけどTMR残基を格納しています
		$ftnumber++;
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){	#FT TRANSMEM行の後ろ2行をfteviに格納
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^\/\//){

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

		printf WRITE ">".$swissid.",".$fteco."\n";
	}

	$swissid = "";
	$ftnumber = 0;
	$ftswitch = 0;
  $fteco = 0;
	$ftevi = "";

}

print chr(7);	#終了時に音が鳴ります
