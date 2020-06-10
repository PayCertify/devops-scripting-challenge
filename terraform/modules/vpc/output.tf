output "rsrc01_internal_id"{
    value = "${aws_security_group.rsrc01_http.id}"
}


output "ecs_security_group"{
    value = "${aws_security_group.ecs_tasks.id}"
}



output "vpc_id" {
    value = "${aws_vpc.rsrc01.0.id}"
}

# output "public_subnet"{
#     value = "${aws_subnet.rsrc01_public.*.cidr_block}"
# }

# output "private_subnet" {
#     value = "${aws_subnet.rsrc01_private.*.cidr_block}"
# }

output "public_subnet_id"{
    value = "${aws_subnet.rsrc01_public.*.id}"
    
}


output "private_subnet_id"{
    value = "${aws_subnet.rsrc01_private.*.id}"
    
}

