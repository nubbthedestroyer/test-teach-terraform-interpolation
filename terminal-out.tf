locals {
  #################################
  # Experiment in here
  #################################









  #################################
  # End Experiment
  #################################

  # BUILD THE FINAL OUTPUT LOCAL
//  outputfinal = "${var.testout}"
}


# Use null resource, local provisioner, and timestamp for trigger so it continues to work after first apply.
resource "null_resource" "local_output" {
  triggers {
    datetime = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "echo ===OUTPUT FROM EXPERIMENT === ${local.outputfinal}"
  }
}