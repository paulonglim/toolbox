#!/bin/bash
# August 20 20202
# CVE-2016-7406 currently only affects X10 motherboard with BMC firmware below  3.46
# X11DPH-T Motherboards seems to be not affected by this vulnerability ( pending verification )

platform_version_base=3.46

vendor_platform=`ipmitool mc info | grep "Manufacturer Name" | awk -F: '{print $2}'| sed "s/^ *//"`

if [[ "$vendor_platform" == "Supermicro" ]]; 
then 

	platform_model=`ipmitool fru | grep "Board Part Number" | awk -F: '{print $2}'| sed "s/^ *//"`
	platform_version=`ipmitool mc info | grep "Firmware Revision" | awk -F: '{print $2}'| sed "s/^ *//" | bc -l`


	if [ "$platform_model" = "X10DRH-iT" ];
	then


		if [[ $platform_version < $platform_version_base ]];
		then

        	platform_serial=`ipmitool fru | grep "Product Serial" | awk -F: '{print $2}'| sed "s/^ *//"`
		platform_bmc_ip=`ipmitool lan print 1 | grep "IP Address   " |  awk -F: '{print $2}'| sed "s/^ *//"`

        	printf "%s" "Affected SuperMicro Platform Serial " "$platform_serial" " BMC IP " "$platform_bmc_ip" " Motherboard Model " "$platform_model" " BMC FW version "  "$platform_version"
		printf "%s\n" 
		exit 3
					
		else

		printf  "%s" "SuperMicro System not affected by CVE-2016-7406 Model " "$platform_model" " BMC version " "$platform_version" 
		printf "%s\n" 
		
		exit 0
		fi
	else

	printf  "%s" "SuperMicro System not affected by CVE-2016-7406 Model " "$platform_model" " BMC version " "$platform_version" 
	printf "%s\n" 
	
	exit 0

	fi
		

else 
	printf  "%s" "This is not a SuperMicro System "
	printf "%s\n" 
	exit 0
fi