curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE=18.2.0}/el9/noarch/cephadm
chmod +x cephadm
./cephadm add-repo --release reef
./cephadm install
./cephadm install  ceph-common

cephadm bootstrap --mon-ip 10.10.10.10 --initial-dashboard-user "cephadmin" --initial-dashboard-password "CEPHADMIN" --dashboard-password-noupdate

ssh-copy-id -f -i /etc/ceph/ceph.pub root@controller1
ssh-copy-id -f -i /etc/ceph/ceph.pub root@controller2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@controller3
ssh-copy-id -f -i /etc/ceph/ceph.pub root@compute1
ssh-copy-id -f -i /etc/ceph/ceph.pub root@compute2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@compute3

ceph orch host add controller1 10.10.10.10
ceph orch host add controller2 10.10.10.11
ceph orch host add controller3 10.10.10.12
ceph orch host add compute1 10.10.10.13
ceph orch host add compute2 10.10.10.14
ceph orch host add compute3 10.10.10.15

ceph orch apply mon --placement="controller1,controller2,controller3,compute1,compute2,compute3"
ceph orch apply mgr --placement="controller1,controller2,controller3,compute1,compute1,compute3"

ceph orch host label add controller1 osd-node
ceph orch host label add controller2 osd-node
ceph orch host label add controller3 osd-node
ceph orch host label add compute1 osd-node
ceph orch host label add compute2 osd-node
ceph orch host label add compute3 osd-node

ceph orch host label add controller1 mon
ceph orch host label add controller2 mon
ceph orch host label add controller3 mon
ceph orch host label add compute1 mon
ceph orch host label add compute2 mon
ceph orch host label add compute3 mon

ceph orch host label add controller1 mgr
ceph orch host label add controller2 mgr
ceph orch host label add controller3 mgr
ceph orch host label add compute1 mgr
ceph orch host label add compute2 mgr
ceph orch host label add compute3 mgr

ceph orch apply osd --all-available-devices
