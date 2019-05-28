Param(
    [parameter(Mandatory = $true)] $ManagementIP,
    [ValidateSet("l2bridge", "overlay", IgnoreCase = $true)] $NetworkMode = "l2bridge",
    [parameter(Mandatory = $false)] $ClusterCIDR = "10.244.0.0/16",
    [parameter(Mandatory = $false)] $KubeDnsServiceIP = "10.96.0.10",
    [parameter(Mandatory = $false)] $LogDir = "C:\k",
    [parameter(Mandatory = $false)] $KubeletSvc = "kubelet",
    [parameter(Mandatory = $false)] $KubeProxySvc = "kube-proxy",
    [parameter(Mandatory = $false)] $FlanneldSvc = "flanneld"
)


$Hostname = $(hostname).ToLower()
$NetworkMode = $NetworkMode.ToLower()

cp .\bin\nssm.exe c:\k\nssm.exe

c:\k\stop.ps1

# register flanneld

if (Get-Service $FlanneldSvc -ErrorAction 'SilentlyContinue') {
    Stop-Service $FlanneldSvc    
    c:\k\nssm.exe remove $FlanneldSvc confirm
}

c:\k\nssm.exe install $FlanneldSvc C:\flannel\flanneld.exe
c:\k\nssm.exe set $FlanneldSvc AppParameters --kubeconfig-file=c:\k\config --iface=$ManagementIP --ip-masq=1 --kube-subnet-mgr=1
c:\k\nssm.exe set $FlanneldSvc AppEnvironmentExtra NODE_NAME=$Hostname
c:\k\nssm.exe set $FlanneldSvc AppStdout C:\flannel\log.txt
c:\k\nssm.exe set $FlanneldSvc AppStderr C:\flannel\log.txt
c:\k\nssm.exe start $FlanneldSvc


if (Get-Service $KubeletSvc -ErrorAction 'SilentlyContinue') {
    Stop-Service $KubeletSvc    
    c:\k\nssm.exe remove $KubeletSvc confirm
}

# register kubelet

c:\k\nssm.exe install $KubeletSvc C:\k\kubelet.exe
c:\k\nssm.exe set $KubeletSvc AppParameters --hostname-override=$Hostname --v=6 --pod-infra-container-image=kubeletwin/pause --resolv-conf="" --allow-privileged=true --enable-debugging-handlers --cluster-dns=$KubeDnsServiceIP --cluster-domain=cluster.local --kubeconfig=c:\k\config --hairpin-mode=promiscuous-bridge --image-pull-progress-deadline=20m --cgroups-per-qos=false  --log-dir=$LogDir --logtostderr=false --enforce-node-allocatable="" --network-plugin=cni --cni-bin-dir=c:\k\cni --cni-conf-dir=c:\k\cni\config
c:\k\nssm.exe set $KubeletSvc AppDirectory C:\k
c:\k\nssm.exe start $KubeletSvc


if (Get-Service $KubeProxySvc -ErrorAction 'SilentlyContinue') {
    Stop-Service $KubeProxySvc   
    c:\k\nssm.exe remove $KubeProxySvc confirm
}

# register kube-proxy
c:\k\nssm.exe install $KubeProxySvc C:\k\kube-proxy.exe
c:\k\nssm.exe set $KubeProxySvc AppDirectory c:\k

if ($NetworkMode -eq "l2bridge") {
    c:\k\nssm.exe set $KubeProxySvc AppEnvironmentExtra KUBE_NETWORK=cbr0
    c:\k\nssm.exe set $KubeProxySvc AppParameters --v=4 --proxy-mode=kernelspace --hostname-override=$Hostname --kubeconfig=c:\k\config --cluster-cidr=$ClusterCIDR --log-dir=$LogDir --logtostderr=false
}
elseif ($NetworkMode -eq "overlay") {
    if ((Test-Path c:/k/sourceVip.json)) {
        $sourceVipJSON = Get-Content sourceVip.json | ConvertFrom-Json 
        $sourceVip = $sourceVipJSON.ip4.ip.Split("/")[0]
    }
    c:\k\nssm.exe set $KubeProxySvc AppParameters --v=4 --proxy-mode=kernelspace --feature-gates="WinOverlay=true" --hostname-override=$Hostname --kubeconfig=c:\k\config --network-name=vxlan0 --source-vip=$sourceVip --enable-dsr=false --cluster-cidr=$ClusterCIDR --log-dir=$LogDir --logtostderr=false
}
c:\k\nssm.exe set $KubeProxySvc DependOnService $KubeletSvc
c:\k\nssm.exe start $KubeProxySvc
