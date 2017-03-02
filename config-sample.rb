# Config 1 - Single VM, Generic Cluster,  Ubuntu 14.04
$boxes = [
  {
    :cluster_size => 1,
    :ram => "2048",
    :os =>  "ubuntu",
    :os_version => "16.10",
    :ansible =>
      [{ :group => "node", :roles => [ "*" ]}],
    :forwarded_ports =>
      { 80 => 8480,
        443 => 8443,
      },
  }
]

# Config 2 - Multi VM, Generic Cluster,  Ubuntu 14.04
# $boxes = [
#   {
#     :cluster_size => 6,
#     :ram => "2048",
#     :os => "ubuntu",
#     :os_version => "14.04",
#     :ansible =>
#       [{ :group => "node", :roles => [ "*" ]}],
#     :forwarded_ports =>
#       { 80 => 8480,
#         443 => 8443,
#       },
#   }
# ]
