resource "aws_instance" "zookeeper"{
    count = var.zookeeper_count
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]
    user_data = templatefile("${path.module}/user_data.sh", {
        myid = count.index +1
        server_list = join(",", [for i in range(var.zookeeper_count) : "server.${i + 1}=${aws_instance.zookeeper[i].private_ip}:2888:3888"])
    })
}