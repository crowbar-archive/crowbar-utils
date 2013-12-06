#!/usr/bin/perl

$command = "swift -V 2 -A http://localhost:5000/v2.0 -U admin:admin -K crowbar --verbose stat";
print "export OS_USERNAME=admin OS_PASSWORD=crowbar OS_TENANT_ID=admin OS_AUTH_URL=http://localhost:5000/v2.0\n"; 

$output = qx/$command/;

foreach  ( split /\n/,$output ) {
	chomp;
	s/^\s*//;
	($name, $value) = split/:\s*/,$_,2;
	
	#print "name $name, value $value\n";
	if ("StorageURL" ~~ $name) {
		print "export OS_STORAGE_URL=${value}\n";
		next;
	}
	if ("Auth Token" ~~ $name) {
		print "export OS_AUTH_TOKEN=${value}\n";
		next;
	}
	
}
	


