hosts_path = r"C:\Windows\System32\drivers\etc\hosts"
with open(hosts_path, "a") as f:
    f.write("\n127.0.0.1 example.local\n")
