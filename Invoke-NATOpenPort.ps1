function Invoke-NATOpenPort 
{
    Param 
    (
            [Parameter(Mandatory=$true, Position=0)]
            [ValidateNotNullOrEmpty()]
            [string]
            $REMOTE_IP,

            [Parameter(Mandatory=$false, Position=1)]
            [int]
            $RPORT = 5060,

            [Parameter(Mandatory=$true, Position=2)]
            [ValidateNotNullOrEmpty()]
            [string]
            
            $LOCAL_IP,
            [Parameter(Mandatory=$false, Position=3)]
            [int]
            $LPORT = 44444

    )

    $conn   = New-Object System.Net.Sockets.TcpClient($REMOTE_IP , $RPORT)
    $stream = $conn.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $writer = New-Object System.IO.StreamWriter($stream)

    $REQUEST = "REGISTER sip:example.org;transport=TCP SIP/2.0
Via: SIP/2.0/TCP ${LOCAL_IP}:${RPORT};branch=I9hG4bK-d8754z-c2ac7de1b3ce90f7-1---d8754z-;rport;transport=TCP
Max-Forwards: 70
Contact: <sip:wuzzi@${LOCAL_IP}:${LPORT};rinstance=v40f3f83b335139c;transport=TCP>
To: <sip:wuzzi@example.org;transport=TCP>
From: <sip:wuzzi@example.org;transport=TCP>;tag=U7c3d519
Call-ID: aaaaaaaaaaaaaaaaa0404aaaaaaaaaaaabbbbbbZjQ4M2M.
CSeq: 1 REGISTER
Expires: 60
Allow: REGISTER, INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Supported: replaces, norefersub, extended-refer, timer, X-cisco-serviceuri
Allow-Events: presence, kpml
Content-Length: 0

"

    foreach($line in $REQUEST)
    {
        $Writer.Write($line)
        $Writer.Flush()
    }

    $reader.ReadToEnd()
    $reader.Close()
    $conn.Close()
   
}
