import sys

lines = [line.rstrip() for line in sys.stdin.readlines()]

i = iter(lines)
while True:
    line = i.next()
    if line.startswith("kubeadm join"):
        print(line.replace("kubeadm join", "kubeadm join -v 19 "))
        while line.endswith("\\"):
            line = i.next()
            print(line)
        break
