locals {
  #################################
  # Experiment in here
  #################################

//  length = 11
//  height = 86
//  area = "${local.length * local.height}"
//
//  cidr_range = "10.0.0.0/16"
//  subnet_mask = "${cidrnetmask(local.cidr_range)}"
//  ip_address = "${cidrhost(local.cidr_range, 5)}"

  #################################
  # End Experiment
  #################################

  # BUILD THE FINAL OUTPUT LOCAL
  outputfinal = "TESTING MY OUTPUT"
}

###################################
# add template file just below when you get to that point
###################################
//data template_file "script" {
//  template = "${file("${path.module}/script.sh.tpl")}"
//  vars {
//    message = "HELLO WORLD"
//  }
//}
###################################

# Use null resource, local provisioner, and timestamp for trigger so it continues to work after first apply.
resource "null_resource" "local_output" {
  triggers {
    datetime = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "echo \"=== OUTPUT FROM EXPERIMENT >>> ${local.outputfinal}\""
  }
}