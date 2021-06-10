<#
This script set configuration of: network, domain/workgroup and machine's rename. More informations in: README.
* start as admin mode *

Author: Matheus Rocha
Country: Brazil
GitHub: /roch4
LinkedIn: /roch4
#>

$clr = Remove-Variable * -ErrorAction SilentlyContinue; Remove-Module *; $error.Clear(); #clean cache -> didn't work as a function
$esc = echo "What do you want to configure? Enter the:"
$op = echo "Enter the option"
$rtrt1 = echo "Restart pending."
$rtrt2 = echo "Please, restart the machine [Option 9]."
$inv = echo "Invalid option."
$idnetph = echo "Now, enter exactly the InterfaceIndex number of the chosen adapter"
$ntwok = echo "Network configure OK."
$cfm = echo "You confirm this? Y - Yes | N - No."

function slcl {
    sleep 2
    cls
}

function yn {
    slcl
    if ($confirm -eq "N") { echo "Start again." }
    elseif ($confirm -ne "Y" -and "N") { $inv } # -ne is different
}

function idnetf {
    $idnet = 0 #reset $idnet
    echo "Find the network adapter do you want to configure:"
    sleep 2
    Get-NetIPAddress #adapter ethernet list
    sleep 2
}

function ntwf { #clear network configs
    Remove-NetIPAddress -InterfaceIndex $idnet -ErrorAction SilentlyContinue #doesn't error show if IP not set
    Remove-NetRoute -InterfaceIndex $idnet -ErrorAction SilentlyContinue #doesn't error show if no routes
}

function timerrest{
    for ($i = 1; $i -le 100; $i++ ){
        Write-Progress -Activity "Restarting..." -Status "$i% Complete:" -PercentComplete $i
        Start-Sleep -Milliseconds 100
    }
    Restart-Computer
}

while ($enter -ne 0){ #-ne is different
    $confirm = 0 #reset $confirm Y|N
    slcl
    $esc
    echo "
    1 - Network
    2 - Domain/Workgroup
    3 - Rename machine
    
    9 - Restart machine
    0 - Exit
    "
    sleep 1

    $enter = Read-Host "$op"
    slcl

    if ($enter -eq 1){ #-eq -> igual
        slcl
        $esc
        echo "
        4 - IPv4
        6 - IPv6

        0 - Exit
        "

        $ipv = Read-Host "$op"

        if ($ipv -eq 4){
            slcl
            $esc
            echo "
            1 - Static IP 
            2 - Dynamic IP 

            0 - Exit
            "
            sleep 1
            $ntw = Read-Host "$op"

            slcl

            if ($ntw -eq 1){ #Static IP
                echo "ATTENTION: all network formats must have DOTS! Example: 172.16.0.1"
                sleep 2
                echo "IPv4 configuration"
                sleep 1
                $ip = Read-Host "Enter the IP adress"
                $gat = Read-Host "Enter the Gateway"
                $dns1 = Read-Host "Enter the preferred DNS" 
                $dns2 = Read-Host "Enter the alternate DNS"

                slcl

                echo "
                Your configurations:

                IP adress: $ip
                Gateway: $gat
                Preferred DNS: $dns1
                Alternate DNS: $dns2
                "

                $confirm = Read-Host "$cfm $op"
                slcl
                if ($confirm -eq "Y"){
                    idnetf
                    $idnet = Read-Host "$idnetph"

                    ntwf #function to clear network settings

                    #Static IP configure
                    New-NetIPAddress $ip -InterfaceIndex $idnet -DefaultGateway $gat -AddressFamily IPv4 -PrefixLength 24 #Adressfamily é necessário p/ mask
                    Set-DnsClientServerAddress -InterfaceIndex $idnet -ServerAddresses $dns1, $dns2 #DNS

                    slcl
                    $ntwok
                    $clr
                } #end if confirm
                yn #funcion: elseif for N or invalid option

           } #end if ntw = 1
           
           elseif ($ntw -eq 2) { #Dynamic IP
                idnetf
                $idnet = Read-Host "$idnetph"

                ntwf #function to clear network settings

                #Dynamic IP configure
                Set-NetIPInterface -InterfaceIndex $idnet -Dhcp Enabled
                Set-DnsClientServerAddress -InterfaceIndex $idnet -ResetServerAddresses #DNS

                slcl
                $ntwok
                $clr
           }

           elseif ($ntw -eq 0){}
                
           else {
                $inv
                $clr
           }
        
        } #end if ipv4

        elseif ($ipv -eq 6) { 
            slcl
            echo "Currently unavailable." 
            $clr
        }

        elseif ($ipv -eq 0) {  } 
        
        else {
            slcl
            $inv
            $clr
        }

    } #end if 1

    elseif ($enter -eq 2 -and $rp -ne 1){ #option 2 and no restart pending

        $esc
        echo "
        1 - Domain
	    2 - Workgroup

	    0 - Exit
        "        
        $dwg = Read-Host "$op"
        slcl

        if ($dwg -eq 1){
            $dom = Read-Host "Enter the domain"
            $confirm = Read-Host "$cfm $op"
            if ($confirm -eq "Y"){
                Add-Computer -DomainName $dom #add domain
                slcl
                echo "Machine added to domain $dom"
                sleep 1
                $rtrt1
                $clr
                $rp = 1 #restart pending
            } #end if Y
            yn #elseif N or invalid option
        } #end if domain

        elseif ($dwg -eq 2){
            $workg = Read-Host "Enter the workgroup"
            $confirm = Read-Host "$cfm $op"
            if ($confirm -eq "Y"){
                add-computer -workgroupname $workg #add workgroup
                slcl
                echo "Machine added to workgroup $workg"
                sleep 1
                $rtrt1           
                $clr
                $rp = 1 #restart pending
            } #end if Y
            yn #elseif N or invalid option
        } #end if workgroup

        elseif ($dwg -eq 0) {}

        else {
            slcl
            $inv
            $clr
        }

    } #end if 2
        
        elseif ($enter -eq 2 -and $rp -eq 1){ #Don't continue. Restart pending
            $rtrt1
            $rtrt2
            sleep 1
            slcl
        } 

    elseif ($enter -eq 3 -and $rp -ne 1){ #option 3 and no restart pending
        slcl
        $nm = Read-Host "New name the machine"
        $confirm = Read-Host "$cfm $op"
        if ($confirm -eq "Y"){
            Rename-Computer -NewName $nm -Force
            slcl
            echo "Machine renamed to $nm"
            sleep 1
            $rtrt1
            $clr
            $rp = 1 #restart pendenting
        } #end if Y
        yn #elseir for N and invalid option
    } #end if rename

        elseif ($enter -eq 3 -and $rp -eq 1){ #Don't continue. Restart pending
            $rtrt1
            $rtrt2
            sleep 1
            slcl
        } 

    elseif ($enter -eq 9){ timerrest } #restart machine

    elseif ($enter -eq 0) {}

    else { #invalid option
        $inv
        $clr
    }
    
}

if ($rp -eq 1){
    $rtrt1
    sleep 1
    echo "Don't forget to restart your machine!" 
    slcl
}
else { }

echo "Exiting..."
slcl