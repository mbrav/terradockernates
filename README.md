# Dockernates

Various docker configurations that integrate with a Kubernates running inside a KVM virtualization enviornment and integration with other components running inside docker such as minikube.

## Use cases

This repository consists of docker-compose configurations for services.

## ℹ️Docker and KVM integration

### Integrating KVM's `default` network with Docker

To allow docker containers access the same network as KVM's net (`virb0`) a MacVLAN van be created:

```bash
virsh net-list
```

```text
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

```bash
virsh net-info default
```

```text
Name:           default
UUID:           46b9f715-39a2-4e83-bcd0-f07049f32ea5
Active:         yes
Persistent:     yes
Autostart:      yes
Bridge:         virbr0
```

Now check your routes

```bash
default via 10.0.59.9 dev enp5s0 proto dhcp src 10.0.59.252 metric 100
10.0.59.0/24 dev enp5s0 proto kernel scope link src 10.0.59.252 metric 100
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1
```

Now we can create the following network in our `docker-compose.yml` config:

```yaml
kvm-net:
  name: kvm-net
  driver: macvlan
  driver_opts:
    parent: virbr0
  ipam:
    config:
      - subnet: 192.168.122.0/24
        gateway: 192.168.122.1
        # Usable IPS's 192.168.122.193 - 192.168.122.254
        # Otherwise use 192.168.122.0/24
        ip_range: 192.168.122.192/26
```
