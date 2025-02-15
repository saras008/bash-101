Markdown

# Setting Up a New Test Kubernetes Environment

This guide outlines the steps to set up a new test Kubernetes environment, including restoring from an etcd backup.

## Prerequisites

* A test machine with a fresh operating system.
* Access to your production environment to copy the etcd backup.

## Steps

### 1. Deploy a New Kubernetes Master Node

On your test machine:

```bash
sudo kubeadm init --pod-network-cidr=192.168.1.0/16
Wait for the initialization to complete. Then, configure kubectl:

Bash

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown <span class="math-inline">\(id \-u\)\:</span>(id -g) $HOME/.kube/config
2. Copy the Backup to the Test Machine
Transfer the etcd backup from your production environment to your test environment:

Production Environment:

Bash

scp /backup/etcd-snapshot.db user@your-test-node:/home/user/
Test Machine:

Bash

sudo mv /home/user/etcd-snapshot.db /backup/
3. Restore etcd Backup on the Test Cluster
Stop etcd:
Bash

sudo systemctl stop etcd
sudo systemctl status etcd  # Verify etcd is stopped
Remove Old etcd Data:
Bash

sudo mv /var/lib/etcd /var/lib/etcd.old
sudo mkdir -p /var/lib/etcd
Restore etcd:
Bash

ETCDCTL_API=3 etcdctl snapshot restore /backup/etcd-snapshot.db --data-dir=/var/lib/etcd
Start and Verify etcd:
Bash

sudo systemctl restart etcd
sudo systemctl status etcd  # Verify etcd is running

ETCDCTL_API=3 etcdctl --endpoints=[https://127.0.0.1:2379](https://127.0.0.1:2379) \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint status --write-out=table
Expected Output:

+--------------------+------------------+---------+---------+-----------+------------+
|     ENDPOINT      |        ID        | VERSION | DB SIZE | LEADER ID | RAFT TERM  |
+--------------------+------------------+---------+---------+-----------+------------+
|  [https://127.0.0.1:2379](https://127.0.0.1:2379)  |  etcd-node-id  | 3.5.9  |  5.0 MB  |  etcd-leader-id  |    5     |
+--------------------+------------------+---------+---------+-----------+------------+
4. Restart Kubernetes Components
Bash

sudo systemctl restart kube-apiserver kube-controller-manager kube-scheduler kubelet
5. Verify Kubernetes is Restored
Bash

kubectl get nodes        # Check cluster status
kubectl get pods -A      # Check if all pods are restored
6. Final Steps: Testing in the New Environment
Access Services:
Bash

kubectl get svc -A
Check Deployments:
Bash

kubectl get deployments -A
Check Pod Logs (if necessary):
Bash

kubectl logs -f <pod-name> -n <namespace>
Summary of Key Commands
Step	Command
Copy backup to test environment	scp /backup/etcd-snapshot.db user@your-test-node:/home/user/
Stop etcd	sudo systemctl stop etcd
Remove old etcd data	sudo mv /var/lib/etcd /var/lib/etcd.old && sudo mkdir -p /var/lib/etcd
Restore etcd backup	ETCDCTL_API=3 etcdctl snapshot restore /backup/etcd-snapshot.db --data-dir=/var/lib/etcd
Restart etcd	sudo systemctl restart etcd
Verify etcd status	etcdctl endpoint status --write-out=table
Restart Kubernetes components	sudo systemctl restart kube-apiserver kube-controller-manager kube-scheduler kubelet
Verify cluster	kubectl get nodes
