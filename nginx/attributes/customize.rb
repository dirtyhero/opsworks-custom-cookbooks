normal[:nginx][:client_max_body_size] = "10m"
normal[:nginx][:proxy_send_timeou] = "300"
normal[:nginx][:worker_processes] = node[:cpu][:total]
